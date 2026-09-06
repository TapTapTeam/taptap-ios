//
//  AnalyticsProviding.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

/// 분석 SDK 하나를 감싸는 최소 인터페이스.
///
/// GA4와 Amplitude를 **둘 다** 붙이는 이유는 하나가 죽거나 수치가 어긋날 때 교차검증하려는 것이다
/// (멘토링 2026-08-29). 그래서 호출부는 프로바이더가 몇 개인지 몰라야 하고,
/// 이벤트 정의는 ``AnalyticsEvent`` 하나로 끝나야 한다.
public protocol AnalyticsProviding: Sendable {
  /// 사람이 읽을 이름 — 로그와 진단에만 쓴다.
  var identifier: String { get }

  /// SDK 초기화. 키가 없으면 아무것도 하지 않고 `false`를 돌려준다.
  @discardableResult
  func start() -> Bool

  func track(_ event: AnalyticsEvent)
  func setUserProperty(_ property: AnalyticsUserProperty)
  func setUserID(_ userID: String?)

  /// 수집 동의 철회 등으로 전송을 끌 때.
  func setCollectionEnabled(_ isEnabled: Bool)
}
