//
//  ArticleWebViewCoordinator.swift
//  OriginalFeature
//
//  Created by Hong on 4/26/26.
//

import WebKit

public final class ArticleWebViewCoordinator: NSObject, WKNavigationDelegate {
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

  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.parent.progress = 1.0
    }

    ArticleScriptInjector.injectArticleScripts(
      into: webView,
      articleItem: parent.articleItem
    )
  }

  public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.parent.progress = 1.0
    }
  }

  public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.parent.progress = 1.0
    }
  }
}
