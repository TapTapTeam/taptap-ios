//
//  MixpanelAnalyticsProvider.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/10/26.
//

import Foundation
import os

import Mixpanel

public final class MixpanelAnalyticsProvider: AnalyticsProviding {
  public let identifier = "Mixpanel"

  private let logger = Logger(subsystem: "TapTap", category: "AnalyticsKit.Mixpanel")

  private let client: MixpanelInstance?

  public init(token: String?, isVerboseLoggingEnabled: Bool = false) {
    guard let token else {
      client = nil
      return
    }

    // trackAutomaticEvents: Amplitude의 [.sessions, .appLifecycles]와 같은 자리다.
    // 세션·앱 생명주기만 자동으로 수집하고 화면 뷰는 포함하지 않는다 — screen_view는
    // 리듀서에서 직접 심는다(뷰 자동수집은 SwiftUI에서 화면 구분이 뭉개진다).
    let instance = Mixpanel.initialize(token: token, trackAutomaticEvents: true)
    instance.loggingEnabled = isVerboseLoggingEnabled
    client = instance
  }

  @discardableResult
  public func start() -> Bool {
    guard let client else {
      logger.notice("MIXPANEL_TOKEN이 비어 있어 Mixpanel을 건너뛴다.")
      return false
    }

    // identify를 한 번도 부르지 않으면 유저 속성이 영원히 전송되지 않는다.
    // `People.addPeopleRecordToQueueWithAction`이 distinctId가 nil일 때 레코드를
    // 미식별 플래그로 저장하고, `loadEntitiesInBatch(type: .people)`은 flag: false인
    // 행만 읽어가서 flush 대상에서 통째로 빠진다 — 큐에는 쌓이는데 나가지는 않는다.
    // 탭탭은 로그인이 없어 setUserID가 불릴 일이 없으므로, SDK가 이미 만들어 둔
    // 익명 distinct_id(`$device:<UUID>`)로 스스로 식별해 그 상태를 푼다.
    // (identify가 `identifyPeople`로 기존 미식별 행의 플래그까지 뒤집는다)
    if !client.distinctId.isEmpty {
      client.identify(distinctId: client.distinctId)
    }
    return true
  }

  public func track(_ event: AnalyticsEvent) {
    guard let client else { return }
    client.track(event: event.name, properties: event.parameters.mapValues(\.mixpanelValue))
  }

  public func setUserProperty(_ property: AnalyticsUserProperty) {
    guard let client else { return }
    client.people.set(properties: [property.name: property.value.mixpanelValue])
  }

  public func setUserID(_ userID: String?) {
    guard let client else { return }
    // Mixpanel의 identify는 nil을 받지 않는다. 사용자를 지우는 것은 reset이고,
    // 그래야 다음 이벤트가 새 distinct_id로 나간다.
    if let userID {
      client.identify(distinctId: userID)
    } else {
      client.reset()
    }
  }

  public func setCollectionEnabled(_ isEnabled: Bool) {
    guard let client else { return }
    if isEnabled {
      client.optInTracking()
    } else {
      client.optOutTracking()
    }
  }
}

/// `AnalyticsValue`가 SDK를 모르게 두려고 여기에 둔다 —
/// `firebaseValue`·`amplitudeValue`는 `Any`라 SDK 타입이 필요 없지만
/// Mixpanel은 `MixpanelType` 프로토콜을 요구해서 import가 따라붙는다.
private extension AnalyticsValue {
  var mixpanelValue: MixpanelType {
    switch self {
    case .string(let value): return value
    case .int(let value): return value
    case .double(let value): return value
    case .bool(let value): return value  // Amplitude와 같이 native boolean. GA4만 문자열이다
    }
  }
}
