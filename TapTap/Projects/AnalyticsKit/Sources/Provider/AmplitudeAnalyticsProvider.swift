//
//  AmplitudeAnalyticsProvider.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation
import os

import AmplitudeSwift

/// Amplitude 프로바이더.
///
/// GA4와 나란히 두는 이유는 리포트를 두 벌 만들려는 게 아니라 **교차검증**이다.
/// 한쪽 SDK가 이벤트를 흘리거나 수치가 어긋날 때 다른 쪽이 기준이 된다.
public final class AmplitudeAnalyticsProvider: AnalyticsProviding {
  public let identifier = "Amplitude"

  private let logger = Logger(subsystem: "TapTap", category: "AnalyticsKit.Amplitude")

  /// 키가 없으면 `nil`. 나중에 갈아끼울 일이 없으니 `let`으로 둬서 이 클래스에 가변 상태를 안 만든다.
  private let client: Amplitude?

  public init(apiKey: String?, isVerboseLoggingEnabled: Bool = false) {
    guard let apiKey else {
      client = nil
      return
    }

    client = Amplitude(
      configuration: Configuration(
        apiKey: apiKey,
        // Debug 빌드에선 업로드 응답(`Handle response, status: 200`)까지 보이게 한다.
        // 기본값 `.warn`으로는 성공한 전송이 아무 로그도 안 남겨서 "붙었는지"를 확인할 방법이 없다.
        // 로그는 subsystem `Amplitude`로 나간다.
        logLevel: isVerboseLoggingEnabled ? .debug : .warn,
        // 세션·앱 생명주기는 GA4가 자동으로 찍는 것과 맞춰 켠다.
        // 화면 뷰 자동수집(`screenViews`)은 UIViewController 기준이라 SwiftUI 앱에선
        // 전부 `UIHostingController`로 뭉개져 쓸모가 없다 — 그래서 끄고 직접 심는다.
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
