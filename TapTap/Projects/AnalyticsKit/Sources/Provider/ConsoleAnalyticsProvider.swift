//
//  ConsoleAnalyticsProvider.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation
import os

public final class ConsoleAnalyticsProvider: AnalyticsProviding {
  public let identifier = "Console"

  private let logger = Logger(subsystem: "TapTap", category: "AnalyticsKit")

  public init() {}

  @discardableResult
  public func start() -> Bool { true }

  public func track(_ event: AnalyticsEvent) {
    let parameters = event.parameters
      .sorted { $0.key < $1.key }
      .map { "\($0.key)=\($0.value.debugDescription)" }
      .joined(separator: " ")

    if parameters.isEmpty {
      logger.debug("📊 \(event.name, privacy: .public)")
    } else {
      logger.debug("📊 \(event.name, privacy: .public) { \(parameters, privacy: .public) }")
    }
  }

  public func setUserProperty(_ property: AnalyticsUserProperty) {
    logger.debug("👤 \(property.name, privacy: .public)=\(property.value.debugDescription, privacy: .public)")
  }

  public func setUserID(_ userID: String?) {
    logger.debug("👤 user_id=\(userID ?? "nil", privacy: .public)")
  }

  public func setCollectionEnabled(_ isEnabled: Bool) {
    logger.debug("📊 collection enabled=\(isEnabled, privacy: .public)")
  }
}
