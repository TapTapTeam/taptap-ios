//
//  ConversionEvent.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

public enum ConversionEvent: AnalyticsEventConvertible, Equatable, Sendable {
  case onboardingCompleted

  case linkSaved(source: LinkSource, hasCategory: Bool)

  case linkOpened(source: LinkSource)

  case linkDeleted(count: Int)

  case highlightCreated

  case memoSaved(isEdit: Bool)

  case categoryCreated(totalCount: Int)

  case linkMovedToCategory(count: Int)

  case searchSubmitted(queryLength: Int, resultCount: Int)

  case highlightDeleted
  case categoryDeleted(linkCount: Int)

  public enum LinkSource: String, Equatable, Sendable {
    case app
    case shareExtension = "share_extension"
    case safariExtension = "safari_extension"
    case search
    case widget
    case unknown
  }

  public var event: AnalyticsEvent {
    switch self {
    case .onboardingCompleted:
      return AnalyticsEvent(name: "onboarding_complete")

    case .linkSaved(let source, let hasCategory):
      return AnalyticsEvent(
        name: "link_save",
        parameters: [
          "link_source": .string(source.rawValue),
          "has_category": .bool(hasCategory)
        ]
      )

    case .linkOpened(let source):
      return AnalyticsEvent(
        name: "link_open",
        parameters: ["link_source": .string(source.rawValue)]
      )

    case .linkDeleted(let count):
      return AnalyticsEvent(
        name: "link_delete",
        parameters: ["item_count": .int(count)]
      )

    case .highlightCreated:
      return AnalyticsEvent(name: "highlight_create")

    case .memoSaved(let isEdit):
      return AnalyticsEvent(
        name: "memo_save",
        parameters: ["is_edit": .bool(isEdit)]
      )

    case .categoryCreated(let totalCount):
      return AnalyticsEvent(
        name: "category_create",
        parameters: ["category_count": .countBucket(totalCount)]
      )

    case .linkMovedToCategory(let count):
      return AnalyticsEvent(
        name: "link_move_category",
        parameters: ["item_count": .int(count)]
      )

    case .searchSubmitted(let queryLength, let resultCount):
      return AnalyticsEvent(
        name: "search_submit",
        parameters: [
          "query_length": .lengthBucket(characters: queryLength),
          "result_count": .int(resultCount),
          "has_result": .bool(resultCount > 0)
        ]
      )

    case .highlightDeleted:
      return AnalyticsEvent(name: "highlight_delete")

    case .categoryDeleted(let linkCount):
      return AnalyticsEvent(
        name: "category_delete",
        parameters: ["item_count": .int(linkCount)]
      )
    }
  }
}
