//
//  AnalyticsEvent.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

public struct AnalyticsEvent: Equatable, Sendable {
  public let name: String
  public let parameters: [String: AnalyticsValue]

  public init(name: String, parameters: [String: AnalyticsValue] = [:]) {
    self.name = name
    self.parameters = parameters
  }
}

public protocol AnalyticsEventConvertible: Sendable {
  var event: AnalyticsEvent { get }
}
