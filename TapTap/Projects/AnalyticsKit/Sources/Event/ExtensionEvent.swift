//
//  ExtensionEvent.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/7/26.
//

import Foundation

public struct ExtensionEvent: AnalyticsEventConvertible {
  public enum DeliveryTrigger: String, Sendable {
    case appLaunch = "app_launch"
    case foreground
  }

  private let name: String
  private let properties: [String: String]
  private let occurredAt: Date
  private let deliveredBy: DeliveryTrigger

  public init(
    name: String,
    properties: [String: String],
    occurredAt: Date,
    deliveredBy: DeliveryTrigger
  ) {
    self.name = name
    self.properties = properties
    self.occurredAt = occurredAt
    self.deliveredBy = deliveredBy
  }

  public var event: AnalyticsEvent {
    var parameters = properties.reduce(into: [String: AnalyticsValue]()) { result, property in
      result[property.key] = Self.typedValue(forKey: property.key, rawValue: property.value)
    }
    parameters["occurred_at"] = .string(Self.formatter.string(from: occurredAt))
    parameters["delivered_by"] = .string(deliveredBy.rawValue)

    return AnalyticsEvent(name: name, parameters: parameters)
  }

  // 확장 이벤트는 앱 그룹 큐를 문자열로만 건너오므로 여기서 원래 타입으로 되돌린다.
  private static func typedValue(forKey key: String, rawValue: String) -> AnalyticsValue {
    switch key {
    case "is_edit":
      return .bool(rawValue == "true")
    case "text_length", "count":
      return Int(rawValue).map(AnalyticsValue.int) ?? .string(rawValue)
    default:
      return .string(rawValue)
    }
  }

  private static let formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()
}
