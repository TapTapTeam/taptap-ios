//
//  FirebaseAnalyticsProvider.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation
import os

import FirebaseAnalytics
import FirebaseCore

public final class FirebaseAnalyticsProvider: AnalyticsProviding {
  public let identifier = "GA4"

  private let logger = Logger(subsystem: "TapTap", category: "AnalyticsKit.GA4")

  public init() {}

  @discardableResult
  public func start() -> Bool {
    guard FirebaseApp.app() == nil else { return true }

    guard let options = FirebaseOptions.defaultOptions() else {
      logger.notice("GoogleService-Info.plist가 없어 GA4를 건너뛴다.")
      return false
    }

    FirebaseApp.configure(options: options)
    return true
  }

  public func track(_ event: AnalyticsEvent) {
    guard isReady else { return }
    Analytics.logEvent(event.name, parameters: event.parameters.mapValues(\.firebaseValue))
  }

  public func setUserProperty(_ property: AnalyticsUserProperty) {
    guard isReady else { return }
    Analytics.setUserProperty(property.value.debugDescription, forName: property.name)
  }

  public func setUserID(_ userID: String?) {
    guard isReady else { return }
    Analytics.setUserID(userID)
  }

  public func setCollectionEnabled(_ isEnabled: Bool) {
    guard isReady else { return }
    Analytics.setAnalyticsCollectionEnabled(isEnabled)
  }

  private var isReady: Bool { FirebaseApp.app() != nil }
}
