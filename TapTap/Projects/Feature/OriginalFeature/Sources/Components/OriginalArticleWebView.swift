//
//  OriginalArticleWebView.swift
//  OriginalFeature
//
//  Created by Hong on 4/27/26.
//

import SwiftUI
import WebKit

import Core

public struct OriginalArticleWebView: UIViewRepresentable {
  let articleItem: ArticleItem
  @Binding var progress: Double
  @ObservedObject private var blockerManager = ContentBlockerManager.shared
  private static var isContentBlockerEnabled: Bool { false }
  
  public init(
    articleItem: ArticleItem,
    progress: Binding<Double>
  ) {
    self.articleItem = articleItem
    self._progress = progress
    if Self.isContentBlockerEnabled {
      Task {
        await ContentBlockerManager.shared.prepare()
      }
    }
  }
  
  public init(
    articleItem: ArticleItem
  ) {
    self.articleItem = articleItem
    self._progress = .constant(1.0)
    if Self.isContentBlockerEnabled {
      Task {
        await ContentBlockerManager.shared.prepare()
      }
    }
  }
  
  public func makeUIView(context: Context) -> WKWebView {
    let configurationResult = ArticleWebViewConfigurationFactory.makeConfiguration(
      contentRuleList: Self.isContentBlockerEnabled ? blockerManager.contentRuleList : nil
    )
    context.coordinator.isRuleListAdded = configurationResult.didAddContentRuleList
    
    let webView = WKWebView(frame: .zero, configuration: configurationResult.configuration)
    webView.navigationDelegate = context.coordinator
    webView.allowsBackForwardNavigationGestures = true
    
    webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
    
    context.coordinator.observation = webView.observe(\.estimatedProgress, options: [.new]) { webView, change in
      DispatchQueue.main.async {
        self.progress = webView.estimatedProgress
      }
    }
    
    return webView
  }
  
  public func updateUIView(_ uiView: WKWebView, context: Context) {
    context.coordinator.parent = self
    
    if Self.isContentBlockerEnabled,
       let ruleList = blockerManager.contentRuleList,
       !context.coordinator.isRuleListAdded {
      uiView.configuration.userContentController.add(ruleList)
      context.coordinator.isRuleListAdded = true
    }
    
    guard let articleURL = URL(string: articleItem.urlString) else {
#if DEBUG
      print("[OriginalArticleWebView] event=invalid_url url=\(articleItem.urlString)")
#endif
      return
    }
    
    if context.coordinator.loadedArticleURL != articleURL.absoluteString {
      context.coordinator.loadedArticleURL = articleURL.absoluteString
#if DEBUG
      print("[OriginalArticleWebView] event=load_start url=\(articleURL.absoluteString)")
#endif
      let request = URLRequest(url: articleURL)
      uiView.load(request)
    } else {
#if DEBUG
      print("[OriginalArticleWebView] event=duplicate_load_skipped url=\(articleURL.absoluteString)")
#endif
    }
  }
  
  public func makeCoordinator() -> ArticleWebViewCoordinator {
    ArticleWebViewCoordinator(self)
  }
}
