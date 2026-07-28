//
//  ArticleWebViewConfigurationFactory.swift
//  OriginalFeature
//
//  Created by Hong on 4/26/26.
//

import WebKit

struct ArticleWebViewConfigurationResult {
  let configuration: WKWebViewConfiguration
  let didAddContentRuleList: Bool
}

enum ArticleWebViewConfigurationFactory {
  static func makeConfiguration(
    contentRuleList: WKContentRuleList?
  ) -> ArticleWebViewConfigurationResult {
    let configuration = WKWebViewConfiguration()
    var didAddContentRuleList = false

    if let contentRuleList {
      configuration.userContentController.add(contentRuleList)
      didAddContentRuleList = true
    }

    configuration.allowsInlineMediaPlayback = true
    configuration.mediaTypesRequiringUserActionForPlayback = .all

    return ArticleWebViewConfigurationResult(
      configuration: configuration,
      didAddContentRuleList: didAddContentRuleList
    )
  }
}
