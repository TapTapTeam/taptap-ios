//
//  ContentBlockerManager.swift
//  OriginalFeature
//
//  Created by Hong on 4/26/26.
//

import SwiftUI
import WebKit
import os

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
        } else {
          continuation.resume(throwing: URLError(.unknown))
        }
      }
    }
  }
}
