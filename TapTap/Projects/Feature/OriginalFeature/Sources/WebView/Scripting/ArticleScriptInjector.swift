//
//  ArticleScriptInjector.swift
//  OriginalFeature
//
//  Created by Hong on 4/26/26.
//

import Core
import Foundation
import WebKit

enum ArticleScriptInjector {
  static func injectArticleScripts(
    into webView: WKWebView,
    articleItem: ArticleItem
  ) {
    guard let jsonString = ArticleHighlightPayloadBuilder.jsonString(from: articleItem) else {
      print("변환 실패")
      return
    }

    injectCss(webView: webView, filename: "OriginalArticleStyle")
    injectJS(webView: webView, filename: "OriginalArticleScript", jsonString: jsonString)
  }

  private static func injectCss(webView: WKWebView, filename: String) {
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

  private static func injectJS(webView: WKWebView, filename: String, jsonString: String) {
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
