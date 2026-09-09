//
//  AmplitudeAnalyticsProvider.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation
import os

import AmplitudeSwift

public final class AmplitudeAnalyticsProvider: AnalyticsProviding {
  public let identifier = "Amplitude"

  private let logger = Logger(subsystem: "TapTap", category: "AnalyticsKit.Amplitude")

  private let client: Amplitude?

  public init(apiKey: String?, isVerboseLoggingEnabled: Bool = false) {
    guard let apiKey else {
      client = nil
      return
    }

    client = Amplitude(
      configuration: Configuration(
        apiKey: apiKey,
        logLevel: isVerboseLoggingEnabled ? .debug : .warn,
        autocapture: [.sessions, .appLifecycles]
      )
    )
  }

  @discardableResult
  public func start() -> Bool {
    guard client != nil else {
      logger.notice("AMPLITUDE_API_KEY가 비어 있어 Amplitude를 건너뛴다.")
      return false
    }
    return true
  }

  public func track(_ event: AnalyticsEvent) {
    guard let client else { return }
    client.track(
      eventType: event.name,
      eventProperties: event.parameters.mapValues(\.amplitudeValue)
    )
  }

  public func setUserProperty(_ property: AnalyticsUserProperty) {
    guard let client else { return }
    client.identify(userProperties: [property.name: property.value.amplitudeValue])
  }

  public func setUserID(_ userID: String?) {
    guard let client else { return }
    client.setUserId(userId: userID)
  }

  public func setCollectionEnabled(_ isEnabled: Bool) {
    client?.configuration.optOut = !isEnabled
  }
}
