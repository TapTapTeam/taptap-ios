//
//  AnalyticsValue.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

public enum AnalyticsValue: Equatable, Sendable {
  case string(String)
  case int(Int)
  case double(Double)
  case bool(Bool)

  var firebaseValue: Any {
    switch self {
    case .string(let value): return value
    case .int(let value): return value
    case .double(let value): return value
    case .bool(let value): return value ? "true" : "false"
    }
  }

  var amplitudeValue: Any {
    switch self {
    case .string(let value): return value
    case .int(let value): return value
    case .double(let value): return value
    case .bool(let value): return value
    }
  }

  var debugDescription: String {
    switch self {
    case .string(let value): return value
    case .int(let value): return String(value)
    case .double(let value): return String(value)
    case .bool(let value): return String(value)
    }
  }
}

public extension AnalyticsValue {
  static func lengthBucket(_ text: String) -> AnalyticsValue {
    lengthBucket(characters: text.count)
  }

  static func lengthBucket(characters: Int) -> AnalyticsValue {
    switch characters {
    case ..<0: return .string("unknown")
    case 0: return .string("0")
    case 1...5: return .string("1-5")
    case 6...15: return .string("6-15")
    case 16...40: return .string("16-40")
    default: return .string("41+")
    }
  }

  static func countBucket(_ count: Int) -> AnalyticsValue {
    switch count {
    case ..<0: return .string("unknown")
    case 0: return .string("0")
    case 1...4: return .string("1-4")
    case 5...19: return .string("5-19")
    case 20...49: return .string("20-49")
    default: return .string("50+")
    }
  }
}
