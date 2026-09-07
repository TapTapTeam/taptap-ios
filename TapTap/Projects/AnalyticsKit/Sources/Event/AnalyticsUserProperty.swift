//
//  AnalyticsUserProperty.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

public enum AnalyticsUserProperty: Equatable, Sendable {
  case hasOnboarded(Bool)

  case savedLinkCount(Int)

  case categoryCount(Int)

  case hasHighlighted(Bool)

  case deviceShell(String)

  var name: String {
    switch self {
    case .hasOnboarded: return "has_onboarded"
    case .savedLinkCount: return "saved_link_count"
    case .categoryCount: return "category_count"
    case .hasHighlighted: return "has_highlighted"
    case .deviceShell: return "device_shell"
    }
  }

  var value: AnalyticsValue {
    switch self {
    case .hasOnboarded(let value): return .bool(value)
    case .savedLinkCount(let count): return .countBucket(count)
    case .categoryCount(let count): return .countBucket(count)
    case .hasHighlighted(let value): return .bool(value)
    case .deviceShell(let shell): return .string(shell)
    }
  }
}
