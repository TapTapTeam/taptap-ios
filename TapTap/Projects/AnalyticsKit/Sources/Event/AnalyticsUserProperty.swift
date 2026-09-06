//
//  AnalyticsUserProperty.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

/// **유저 프로퍼티** — 이벤트가 아니라 사람에 붙는 값.
///
/// 파라미터와 헷갈리기 쉬운데 귀속 대상이 다르다.
/// `link_save`의 `link_source`는 그 저장 한 번에 붙고(파라미터),
/// `saved_link_count`는 그 사람에게 붙어 이후 모든 이벤트에 따라다닌다(프로퍼티).
/// 프로퍼티가 있어야 "링크 20개 이상 모은 유저의 검색 사용률" 같은 그룹핑이 된다.
///
/// GA4는 유저 프로퍼티를 계정당 25개까지만 받으므로 함부로 늘리지 않는다.
public enum AnalyticsUserProperty: Equatable, Sendable {
  /// 온보딩을 마친 사람인지.
  case hasOnboarded(Bool)

  /// 저장한 링크 수 — 원값이 아니라 구간. 원값은 카디널리티가 높아 그룹핑에 못 쓴다.
  case savedLinkCount(Int)

  /// 만든 카테고리 수 구간.
  case categoryCount(Int)

  /// 하이라이트를 한 번이라도 남겼는지 — 탭탭의 핵심 기능 도달 여부.
  case hasHighlighted(Bool)

  /// 어떤 셸에서 쓰는지 (phone / pad / mac).
  case deviceShell(String)

  var name: String {
    switch self {
    case .hasOnboarded: return "has_onboarded"
    case .savedLinkCount: return "saved_link_count"
    case .categoryCount: return "category_count"
    case .hasHighlighted: return "has_highlighted"
    case .deviceShell: return "device_shell"
    }
  }

  var value: AnalyticsValue {
    switch self {
    case .hasOnboarded(let value): return .bool(value)
    case .savedLinkCount(let count): return .countBucket(count)
    case .categoryCount(let count): return .countBucket(count)
    case .hasHighlighted(let value): return .bool(value)
    case .deviceShell(let shell): return .string(shell)
    }
  }
}
