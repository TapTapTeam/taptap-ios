//
//  AnalyticsClient.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

import ComposableArchitecture

/// 리듀서에서 쓰는 계측 창구.
///
/// ```swift
/// @Dependency(\.analytics) var analytics
/// ...
/// case .saveLinkResponse(let article):
///   analytics.track(ConversionEvent.linkSaved(source: .app, hasCategory: ...))
/// ```
///
/// 뷰가 아니라 리듀서에서 부르는 게 핵심이다. 뷰에 심으면 UI를 바꿀 때마다 전환 지표가 끊긴다.
public struct AnalyticsClient: Sendable {
  public var start: @Sendable () -> Void
  public var trackEvent: @Sendable (AnalyticsEvent) -> Void
  public var setUserProperty: @Sendable (AnalyticsUserProperty) -> Void
  public var setUserID: @Sendable (String?) -> Void
  public var setCollectionEnabled: @Sendable (Bool) -> Void

  public init(
    start: @escaping @Sendable () -> Void,
    trackEvent: @escaping @Sendable (AnalyticsEvent) -> Void,
    setUserProperty: @escaping @Sendable (AnalyticsUserProperty) -> Void,
    setUserID: @escaping @Sendable (String?) -> Void,
    setCollectionEnabled: @escaping @Sendable (Bool) -> Void
  ) {
    self.start = start
    self.trackEvent = trackEvent
    self.setUserProperty = setUserProperty
    self.setUserID = setUserID
    self.setCollectionEnabled = setCollectionEnabled
  }
}

public extension AnalyticsClient {
  /// 호출부는 항상 이 쪽을 쓴다 — 이벤트 이름 문자열이 호출부로 새 나가지 않게.
  func track(_ event: some AnalyticsEventConvertible) {
    trackEvent(event.event)
  }
}

public extension AnalyticsClient {
  static func live(service: AnalyticsService) -> AnalyticsClient {
    AnalyticsClient(
      start: { service.start() },
      trackEvent: { service.track($0) },
      setUserProperty: { service.setUserProperty($0) },
      setUserID: { service.setUserID($0) },
      setCollectionEnabled: { service.setCollectionEnabled($0) }
    )
  }

  static let noop = AnalyticsClient(
    start: {},
    trackEvent: { _ in },
    setUserProperty: { _ in },
    setUserID: { _ in },
    setCollectionEnabled: { _ in }
  )
}

extension AnalyticsClient: DependencyKey {
  public static let liveValue = AnalyticsClient.live(service: .shared)

  /// 테스트에서는 조용히 버린다.
  ///
  /// TCA 관례상 `unimplemented`를 쓰지만, 계측은 부수효과라 그렇게 두면
  /// 계측을 심을 때마다 상관없는 기존 테스트가 깨진다. 계측 자체를 검증하고 싶으면
  /// 그 테스트에서 `$0.analytics`를 직접 갈아끼운다.
  public static let testValue = AnalyticsClient.noop

  public static let previewValue = AnalyticsClient.live(
    service: AnalyticsService(providers: [ConsoleAnalyticsProvider()])
  )
}

public extension DependencyValues {
  var analytics: AnalyticsClient {
    get { self[AnalyticsClient.self] }
    set { self[AnalyticsClient.self] = newValue }
  }
}
