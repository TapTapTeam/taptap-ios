//
//  AnalyticsService.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation
import os

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
