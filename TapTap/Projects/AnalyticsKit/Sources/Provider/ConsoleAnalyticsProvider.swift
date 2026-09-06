//
//  ConsoleAnalyticsProvider.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation
import os

/// 콘솔로만 찍는 프로바이더.
///
/// 두 가지 용도가 있다.
/// 1. 키가 아직 없어도 "무엇이 언제 찍히는지"를 눈으로 확인할 수 있다.
/// 2. GA4 DebugView는 반영이 늦어서, 심는 시점이 맞는지 보려면 로컬 로그가 더 빠르다.
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
