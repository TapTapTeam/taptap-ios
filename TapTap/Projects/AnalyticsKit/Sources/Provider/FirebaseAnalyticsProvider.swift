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

/// GA4 프로바이더.
///
/// 앱에서 GA4는 Firebase Analytics SDK가 사실상 유일한 공식 경로다. 웹처럼 URL만으로 자동
/// 수집되는 게 없으므로 이벤트는 전부 수동으로 심는다. 대신 `first_open`·`session_start`·
/// `user_engagement` 같은 기본 이벤트는 SDK가 알아서 찍는다.
public final class FirebaseAnalyticsProvider: AnalyticsProviding {
  public let identifier = "GA4"

  private let logger = Logger(subsystem: "TapTap", category: "AnalyticsKit.GA4")

  public init() {}

  /// `GoogleService-Info.plist`가 없으면 `FirebaseApp.configure()`는 그냥 실패가 아니라
  /// **앱을 죽인다**(fatalError). 키를 아직 안 받은 상태에서도 앱은 돌아가야 하므로 먼저 확인한다.
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
    // GA4 유저 프로퍼티는 문자열만 받는다 — 숫자를 넣어도 문자열로 저장되므로 여기서 맞춰 보낸다.
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
