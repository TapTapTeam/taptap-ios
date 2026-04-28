//
//  ArticleScriptInjector.swift
//  OriginalFeature
//
//  Created by Hong on 4/26/26.
//

import Core
import Foundation
import OSLog
import WebKit

enum ArticleScriptInjector {
  private static let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "TapTap",
    category: "ArticleScriptInjector"
  )
  
  static func injectArticleScripts(
    into webView: WKWebView,
    articleItem: ArticleItem
  ) {
    do {
      let jsonString = try ArticleHighlightPayloadBuilder.jsonString(from: articleItem)
      
      injectCss(webView: webView, filename: "OriginalArticleStyle")
      injectJS(webView: webView, filename: "OriginalArticleScript", jsonString: jsonString)
    } catch {
      logger.error("하이라이트 JSON 생성 실패: \(error.localizedDescription, privacy: .public)")
    }
  }

  private static func injectCss(webView: WKWebView, filename: String) {
    let bundle = Bundle.module

    guard
      let cssPath = bundle.path(forResource: filename, ofType: "css")
    else {
      logger.error("CSS 파일을 찾지 못함: \(filename, privacy: .public).css")
      return
    }

    guard
      let cssString = try? String(contentsOfFile: cssPath, encoding: .utf8)
        .replacingOccurrences(of: "\n", with: "")
    else {
      logger.error("CSS 파일 읽기 실패: \(filename, privacy: .public).css")
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
        logger.error("CSS 주입 오류: \(error.localizedDescription, privacy: .public)")
      }
    }
  }
  
  /// injectJS
  /// - Parameters:
  ///   - webView: WKWebView
  ///   - filename: javascript 파일 이름
  ///   - jsonString: swiftData의 json타입
  private static func injectJS(
    webView: WKWebView,
    filename: String,
    jsonString: String
  ) {
    let bundle = Bundle.module

    guard
      let jsPath = bundle.path(forResource: filename, ofType: "js")
    else {
      logger.error("JS 파일을 찾지 못함: \(filename, privacy: .public).js")
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
          logger.error("JS 실행 오류: \(error.localizedDescription, privacy: .public)")
        }
      }
    } catch {
      logger.error("JS 파일 로드 실패: \(error.localizedDescription, privacy: .public)")
    }
  }
}
