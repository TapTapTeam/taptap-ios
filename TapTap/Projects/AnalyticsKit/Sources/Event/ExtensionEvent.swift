//
//  ExtensionEvent.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/7/26.
//

import Foundation

public struct ExtensionEvent: AnalyticsEventConvertible {
  private let name: String
  private let properties: [String: String]
  private let occurredAt: Date

  public init(name: String, properties: [String: String], occurredAt: Date) {
    self.name = name
    self.properties = properties
    self.occurredAt = occurredAt
  }

  public var event: AnalyticsEvent {
    var parameters: [String: AnalyticsValue] = properties.mapValues { .string($0) }
    parameters["occurred_at"] = .string(Self.formatter.string(from: occurredAt))
    parameters["delivered_by"] = .string("app_launch")

    return AnalyticsEvent(name: name, parameters: parameters)
  }

  private static let formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()
}
