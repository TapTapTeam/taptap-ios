//
//  ArticleWebViewCoordinator.swift
//  OriginalFeature
//
//  Created by Hong on 4/26/26.
//

import OSLog
import WebKit

public final class ArticleWebViewCoordinator: NSObject, WKNavigationDelegate {
  private let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "TapTap",
    category: "ArticleWebViewCoordinator"
  )
  
  var parent: OriginalArticleWebView
  var observation: NSKeyValueObservation?
  var isRuleListAdded: Bool = false
  var loadedArticleURL: String?

  public init(_ parent: OriginalArticleWebView) {
    self.parent = parent
  }

  deinit {
    observation?.invalidate()
  }

  public func webView(
    _ webView: WKWebView,
    didFinish navigation: WKNavigation!
  ) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.parent.progress = 1.0
      self.parent.onLoadEvent(.succeeded)
    }

    ArticleScriptInjector.injectArticleScripts(
      into: webView,
      articleItem: parent.articleItem
    )
  }

  public func webView(
    _ webView: WKWebView,
    didFailProvisionalNavigation navigation: WKNavigation!,
    withError error: Error
  ) {
    handleLoadFailure(error)
  }

  public func webView(
    _ webView: WKWebView,
    didFail navigation: WKNavigation!,
    withError error: Error
  ) {
    handleLoadFailure(error)
  }
  
  private func handleLoadFailure(_ error: Error) {
    let nsError = error as NSError
    if nsError.domain == NSURLErrorDomain,
       nsError.code == NSURLErrorCancelled {
      return
    }
    
    logger.error("WebView 로드 실패: \(error.localizedDescription, privacy: .public)")
    
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.parent.progress = 1.0
      self.parent.onLoadEvent(.failed(message: "페이지를 불러올 수 없습니다."))
    }
  }
}
