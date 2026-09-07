//
//  ConversionEvent.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

/// **전환 이벤트** — 사용자가 탭탭에서 "해냈다"고 볼 수 있는 행동.
///
/// 화면이 어떻게 바뀌든 이름과 의미가 그대로여야 한다. 링크 추가를 한 화면에서 받든
/// 시트를 거쳐 받든 `link_save`는 똑같이 한 번 찍혀야, UI를 갈아엎어도 지표가 끊기지 않는다.
/// 그래서 여기 있는 이벤트는 **뷰가 아니라 리듀서의 성공 액션**에서만 발화시킨다.
///
/// UI가 바뀌면 같이 사라져도 되는 것은 ``UsageEvent``로 간다.
public enum ConversionEvent: AnalyticsEventConvertible, Equatable, Sendable {
  /// 온보딩을 끝까지 마쳤다.
  case onboardingCompleted

  /// 링크를 저장했다 (탭탭의 핵심 전환).
  case linkSaved(source: LinkSource, hasCategory: Bool)

  /// 저장한 링크를 다시 열었다 — 저장만 하고 안 읽는 유저와 구분하는 지표.
  case linkOpened(source: LinkSource)

  /// 저장한 링크를 지웠다.
  case linkDeleted(count: Int)

  /// 본문에 하이라이트를 남겼다.
  case highlightCreated

  /// 하이라이트에 메모를 붙였다.
  case memoSaved(isEdit: Bool)

  /// 카테고리를 새로 만들었다.
  case categoryCreated(totalCount: Int)

  /// 링크를 카테고리로 옮겼다.
  case linkMovedToCategory(count: Int)

  /// 검색을 실행하고 결과를 받았다.
  case searchSubmitted(queryLength: Int, resultCount: Int)

  /// 하이라이트를 지웠다.
  case highlightDeleted

  /// 카테고리를 지웠다 — 딸린 링크가 몇 개였는지 같이 본다.
  case categoryDeleted(linkCount: Int)

  /// 링크가 어디서 들어오고 어디서 열렸는지.
  ///
  /// 사파리 확장·공유 시트가 실제로 쓰이는지가 탭탭의 제품 가설 자체라 반드시 나눠서 본다.
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
      // 검색어 원문은 보내지 않는다 — 개인정보이고, GA4 파라미터 100자 제한에 걸려 뭉개진다.
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
