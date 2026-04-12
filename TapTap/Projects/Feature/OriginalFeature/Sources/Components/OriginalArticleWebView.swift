//
//  OriginalWebView.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import SwiftUI
import WebKit
import os

import Core

@MainActor
public final class ContentBlockerManager: ObservableObject {
  public static let shared = ContentBlockerManager()
  
  @Published public private(set) var contentRuleList: WKContentRuleList?
  private var preparationTask: Task<WKContentRuleList, Error>?
  
  private init() {}
  
  public func prepare() async {
    if contentRuleList != nil { return }
    
    if let existingTask = preparationTask {
      _ = try? await existingTask.value
      return
    }
    
    let newTask = Task { () -> WKContentRuleList in
      let identifier = "SafeContentBlocker"
      if let existing = await lookup(identifier: identifier) {
        return existing
      }

      let rules = """
      [
        {
          "trigger": 
            { 
              "url-filter": ".*(doubleclick\\\\.net|google-analytics\\\\.com|googlesyndication\\\\.com|amazon-adsystem\\\\.com|adnxs\\\\.com|adservice\\\\.google|analytics\\\\.google\\\\.com).*"
            },
            "action": { "type": "block" }
          }
        ]
      """
      return try await compile(identifier: identifier, encodedRules: rules)
    }
    
    preparationTask = newTask
    
    do {
      self.contentRuleList = try await newTask.value
    } catch {
      os_log("ContentBlocker 준비 실패: \(error.localizedDescription)")
    }
    
    preparationTask = nil
  }
  
  private func lookup(identifier: String) async -> WKContentRuleList? {
    await withCheckedContinuation { continuation in
      WKContentRuleListStore.default().lookUpContentRuleList(forIdentifier: identifier) { ruleList, _ in
        continuation.resume(returning: ruleList)
      }
    }
  }
  
  private func compile(
    identifier: String,
    encodedRules: String
  ) async throws -> WKContentRuleList {
    try await withCheckedThrowingContinuation { continuation in
      WKContentRuleListStore.default().compileContentRuleList(
        forIdentifier: identifier,
        encodedContentRuleList: encodedRules
      ) { ruleList, error in
          if let error = error {
            continuation.resume(throwing: error)
          } else if let ruleList = ruleList {
            continuation.resume(returning: ruleList)
          }
        }
    }
  }
}

public struct OriginalArticleWebView: UIViewRepresentable {
  let articleItem: ArticleItem
  @Binding var progress: Double
  @ObservedObject private var blockerManager = ContentBlockerManager.shared
  
  public init(
    articleItem: ArticleItem,
    progress: Binding<Double>
  ) {
    self.articleItem = articleItem
    self._progress = progress
    Task {
      await ContentBlockerManager.shared.prepare()
    }
  }
  
  public init(
    articleItem: ArticleItem
  ) {
    self.articleItem = articleItem
    self._progress = .constant(1.0)
    Task {
      await ContentBlockerManager.shared.prepare()
    }
  }
  
  public func makeUIView(context: Context) -> WKWebView {
    let configuration = WKWebViewConfiguration()
    if let ruleList = blockerManager.contentRuleList {
      configuration.userContentController.add(ruleList)
      context.coordinator.isRuleListAdded = true
    }
    
    // 미디어 최적화: 자동 재생 방지 및 인라인 재생 허용
    configuration.allowsInlineMediaPlayback = true
    configuration.mediaTypesRequiringUserActionForPlayback = .all
    
    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = context.coordinator
    webView.allowsBackForwardNavigationGestures = true
    
    // 모바일 최적화된 페이지를 위해 User-Agent 설정
    webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
    
    // progress 관찰을 위한 KVO 등록
    context.coordinator.observation = webView.observe(\.estimatedProgress, options: [.new]) { webView, change in
      DispatchQueue.main.async {
        self.progress = webView.estimatedProgress
      }
    }
    
    return webView
  }
  
  public func updateUIView(_ uiView: WKWebView, context: Context) {
    if let ruleList = blockerManager.contentRuleList, !context.coordinator.isRuleListAdded {
      uiView.configuration.userContentController.add(ruleList)
      context.coordinator.isRuleListAdded = true
    }
    
    guard let articleURL = URL(string: articleItem.urlString) else {
      return
    }
    
    let currentURLString = uiView.url?.absoluteString
    if currentURLString == nil || (currentURLString != articleURL.absoluteString && !uiView.isLoading) {
      let request = URLRequest(url: articleURL)
      uiView.load(request)
    }
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, WKNavigationDelegate {
    var parent: OriginalArticleWebView
    var observation: NSKeyValueObservation?
    var isRuleListAdded: Bool = false
    
    public init(_ parent: OriginalArticleWebView) {
      self.parent = parent
    }
    
    deinit {
      observation?.invalidate()
    }
    
    //로딩 완료 시점
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      DispatchQueue.main.async {
        self.parent.progress = 1.0
      }
      
      let highlightsJSON = (parent.articleItem.highlights ?? []).map { item in
        return [
          "id": item.id,
          "sentence": item.sentence,
          "type": item.type,
          "comments": item.comments.map { comment in
            return [
              "id": comment.id,
              "type": comment.type,
              "text": comment.text
            ]
          }
        ]
      }
      
      guard let jsonData = try? JSONSerialization.data(withJSONObject: highlightsJSON, options: []),
            let jsonString = String(data: jsonData, encoding: .utf8) else {
        print("변환 실패")
        return
      }
      //CSS와 JS 주입완료시점
      injectCss(webView: webView, filename: "OriginalArticleStyle")
      injectJS(webView: webView, filename: "OriginalArticleScript", jsonString: jsonString)
    }
    
    //인터넷 연결이 끊기는 에러등
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      DispatchQueue.main.async {
        self.parent.progress = 1.0
      }
    }
    
    //로딩 중 에러
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      DispatchQueue.main.async {
        self.parent.progress = 1.0
      }
    }
    
    private func injectCss(webView: WKWebView, filename: String) {
      let bundle = Bundle.module
      
      guard let cssPath = bundle.path(forResource: filename, ofType: "css") else {
        print("\(filename).css 를 찾지 못함")
        return
      }
      
      guard let cssString = try? String(contentsOfFile: cssPath, encoding: .utf8)
        .replacingOccurrences(of: "\n", with: "") else {
        print("CSS 파일 읽기 실패")
        return
      }
      
      let javascript = """
        var style = document.createElement('style');
        style.innerHTML = `\(cssString)`;
        document.head.appendChild(style);
        void 0;
      """
      
      webView.evaluateJavaScript(javascript) { _, error in
        if let error = error {
          print("CSS 주입 오류: \(error)")
        }
      }
    }
    
    private func injectJS(webView: WKWebView, filename: String, jsonString: String) {
      let bundle = Bundle.module
      
      guard let jsPath = bundle.path(forResource: filename, ofType: "js") else {
        print("\(filename).js 를 찾지 못함")
        return
      }
      
      do {
        let scriptContent = try String(contentsOfFile: jsPath, encoding: .utf8)
        let fullScript = """
          \(scriptContent)
          applyHighlights(\(jsonString));
          void 0;
        """
        
        webView.evaluateJavaScript(fullScript) { _, error in
          if let error = error {
            print("JS 실행 오류: \(error)")
          }
        }
      } catch {
        print("JS 파일 로드 실패: \(error)")
      }
    }
  }
}
