//
//  OriginalEditWebView.swift
//  Feature
//
//  Created by 여성일 on 11/7/25.
//

import SwiftUI
import WebKit

import ComposableArchitecture

import Core

public struct OriginalEditWebView: UIViewRepresentable {
  let articleItem: ArticleItem
  let store: StoreOf<OriginalEditFeature>
  @Binding var progress: Double
  
  public init(
    articleItem: ArticleItem,
    store: StoreOf<OriginalEditFeature>,
    progress: Binding<Double>
  ) {
    self.articleItem = articleItem
    self.store = store
    self._progress = progress
  }
  
  public func makeUIView(context: Context) -> WKWebView {
    let userContentController = WKUserContentController()
    userContentController.add(context.coordinator, name: "editHandler")
    
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController
    
    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = context.coordinator
    
    // progress 관찰을 위한 KVO 등록
    context.coordinator.observation = webView.observe(\.estimatedProgress, options: [.new]) { webView, change in
      DispatchQueue.main.async {
        self.progress = webView.estimatedProgress
      }
    }
    
    return webView
  }
  
  public func updateUIView(_ uiView: WKWebView, context: Context) {
    if store.isDataRequestTriggered {
      context.coordinator.getHighlightsData(webView: uiView)
    } else {
      guard let articleURL = URL(string: articleItem.urlString) else {
        return
      }
      
      if uiView.url?.absoluteString != articleURL.absoluteString {
        let request = URLRequest(url: articleURL)
        uiView.load(request)
      }
    }
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    var parent: OriginalEditWebView
    var observation: NSKeyValueObservation?
    
    init(_ parent: OriginalEditWebView) {
      self.parent = parent
    }
    
    deinit {
      observation?.invalidate()
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      if message.name == "editHandler", let body = message.body as? [[String: Any]] {
        do {
          let data = try JSONSerialization.data(withJSONObject: body, options: [])
          
          let payloads = try JSONDecoder().decode([HighlightPayload].self, from: data)
          
          parent.store.send(.highlightsDataResponse(payloads))
        } catch {
          print("userContentController 전송 에러")
        }
      }
    }
    
    public func getHighlightsData(webView: WKWebView) {
      webView.evaluateJavaScript("getAllHighlightsData();") { _, error in
        if let error = error {
          print("getHighlightsData evaluate 에러 \(error)")
        }
      }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      // 로딩 완료 시 progress를 1.0으로 설정
      DispatchQueue.main.async {
        self.parent.progress = 1.0
      }
      
      let highlightsJSON = parent.articleItem.highlights.map { item in
        return [
          "id": item.id,
          "sentence": item.sentence,
          "type": item.type,
          "comments": item.comments.map { comment in
            return [
              "id": comment.id,
              "type": comment.type,
              "text": comment.text,
            ]
          },
        ]
      }
      
      guard
        let jsonData = try? JSONSerialization.data(withJSONObject: highlightsJSON, options: []),
        let jsonString = String(data: jsonData, encoding: .utf8)
      else {
        print("변환 실패")
        return
      }
      
      injectCss(webView: webView, filename: "OriginalEditStyle")
      injectJS(webView: webView, filename: "OriginalEditScript", jsonString: jsonString)
    }
    
    private func injectCss(webView: WKWebView, filename: String) {
      let bundle = Bundle.module
      
      guard let cssPath = bundle.path(forResource: filename, ofType: "css") else {
        print("\(filename).css 를 찾지 못함")
        return
      }
      
      guard
        let cssString = try? String(contentsOfFile: cssPath)
          .replacingOccurrences(of: "\n", with: "")
      else {
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
        let scriptContent = try String(contentsOfFile: jsPath)
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
