//
//  AnalyticsClient.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

import ComposableArchitecture

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
