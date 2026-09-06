//
//  AnalyticsService.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation
import os

/// 이벤트 하나를 붙어 있는 모든 프로바이더로 흘려보낸다.
///
/// 호출부는 GA4가 있는지 Amplitude가 있는지 몰라야 한다. 나중에 어트리뷰션 툴
/// (AppsFlyer / Airbridge)을 붙일 때도 프로바이더 하나를 추가하면 끝나도록 여기서 갈라둔다.
public final class AnalyticsService: Sendable {
  public static let shared = AnalyticsService(
    configuration: .fromMainBundle()
  )

  private let providers: [any AnalyticsProviding]
  private let logger = Logger(subsystem: "TapTap", category: "AnalyticsKit")

  public init(configuration: AnalyticsConfiguration) {
    var providers: [any AnalyticsProviding] = []

    if configuration.isDebugLoggingEnabled {
      providers.append(ConsoleAnalyticsProvider())
    }
    if configuration.hasFirebaseConfigFile {
      providers.append(FirebaseAnalyticsProvider())
    }
    if configuration.amplitudeAPIKey != nil {
      providers.append(
        AmplitudeAnalyticsProvider(
          apiKey: configuration.amplitudeAPIKey,
          isVerboseLoggingEnabled: configuration.isDebugLoggingEnabled
        )
      )
    }

    self.providers = providers
  }

  public init(providers: [any AnalyticsProviding]) {
    self.providers = providers
  }

  /// 앱 시작 시 한 번. 키가 없는 프로바이더는 조용히 빠지고 앱은 그대로 굴러간다.
  public func start() {
    let started = providers.filter { $0.start() }.map(\.identifier)
    if started.isEmpty {
      logger.notice("활성 분석 프로바이더가 없다 — 키를 넣기 전까지 이벤트는 버려진다.")
    } else {
      logger.notice("분석 프로바이더 시작: \(started.joined(separator: ", "), privacy: .public)")
    }
  }

  public func track(_ event: AnalyticsEvent) {
    providers.forEach { $0.track(event) }
  }

  public func setUserProperty(_ property: AnalyticsUserProperty) {
    providers.forEach { $0.setUserProperty(property) }
  }

  public func setUserID(_ userID: String?) {
    providers.forEach { $0.setUserID(userID) }
  }

  public func setCollectionEnabled(_ isEnabled: Bool) {
    providers.forEach { $0.setCollectionEnabled(isEnabled) }
  }
}
