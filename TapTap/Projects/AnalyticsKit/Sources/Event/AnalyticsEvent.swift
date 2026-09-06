//
//  AnalyticsEvent.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

/// 이벤트 하나가 프로바이더로 나갈 때의 최종 형태.
public struct AnalyticsEvent: Equatable, Sendable {
  public let name: String
  public let parameters: [String: AnalyticsValue]

  public init(name: String, parameters: [String: AnalyticsValue] = [:]) {
    self.name = name
    self.parameters = parameters
  }
}

/// 이벤트 정의는 전부 이 프로토콜을 통해 `AnalyticsEvent`로 환원된다.
///
/// 정의를 타입으로 두는 이유는 멘토링(2026-08-29)의 세 번째 원칙 때문이다 —
/// "정의의 원천을 한 곳에 둔다". 팀이 전원 개발자라 문서 대신 타입을 원천으로 삼고,
/// 사람이 읽을 표는 `Docs/analytics-events.md`가 이 타입들을 그대로 옮겨 적는다.
public protocol AnalyticsEventConvertible: Sendable {
  var event: AnalyticsEvent { get }
}
