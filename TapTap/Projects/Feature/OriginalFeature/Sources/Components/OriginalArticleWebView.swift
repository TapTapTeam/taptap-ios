//
//  OriginalWebView.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import SwiftUI
import WebKit

import Core

public struct OriginalArticleWebView: UIViewRepresentable {
  let articleItem: ArticleItem
  @Binding var progress: Double
  private static var contentRuleList: WKContentRuleList?
  
  private static func prepareContentBlocker() {
    guard contentRuleList == nil else { return }
    
    // 안전한 네트워크 레벨 차단 규칙 (광고, 트래커, 분석 도구)
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
    
    WKContentRuleListStore.default().compileContentRuleList(
      forIdentifier: "SafeContentBlocker",
      encodedContentRuleList: rules) { ruleList, _ in
        Self.contentRuleList = ruleList
      }
  }
  
  public init(
    articleItem: ArticleItem,
    progress: Binding<Double>
  ) {
    self.articleItem = articleItem
    self._progress = progress
    Self.prepareContentBlocker()
  }
  
  public init(
    articleItem: ArticleItem
  ) {
    self.articleItem = articleItem
    self._progress = .constant(1.0)
    Self.prepareContentBlocker()
  }
  
  public func makeUIView(context: Context) -> WKWebView {
    let configuration = WKWebViewConfiguration()
    
    if let ruleList = Self.contentRuleList {
      configuration.userContentController.add(ruleList)
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
    guard let articleURL = URL(string: articleItem.urlString) else {
      return
    }
    
    if uiView.url?.absoluteString != articleURL.absoluteString {
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
    
    public init(_ parent: OriginalArticleWebView) {
      self.parent = parent
    }
    
    deinit {
      observation?.invalidate()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      // 로딩 완료 시 progress를 1.0으로 명시적 설정
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
      
      injectCss(webView: webView, filename: "OriginalArticleStyle")
      injectJS(webView: webView, filename: "OriginalArticleScript", jsonString: jsonString)
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
