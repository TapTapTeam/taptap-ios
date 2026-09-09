//
//  ExtensionAnalyticsQueue.swift
//  Core
//

import Foundation

public struct QueuedAnalyticsEvent: Sendable, Equatable {
  public let name: String
  public let properties: [String: String]
  public let occurredAt: Date

  public init(name: String, properties: [String: String], occurredAt: Date) {
    self.name = name
    self.properties = properties
    self.occurredAt = occurredAt
  }
}

public enum ExtensionAnalyticsQueue {
  private static let appGroupID = "group.com.nbs.dev.ADA.shared"
  private static let storageKey = "analytics.pendingExtensionEvents"
  private static let maxCount = 200

  private static var defaults: UserDefaults? {
    UserDefaults(suiteName: appGroupID)
  }

  public static func append(name: String, properties: [String: String]) {
    guard let defaults, !name.isEmpty else { return }

    var stored = defaults.array(forKey: storageKey) as? [[String: Any]] ?? []
    stored.append([
      "name": name,
      "properties": properties,
      "occurredAt": Date().timeIntervalSince1970
    ])

    if stored.count > maxCount {
      stored.removeFirst(stored.count - maxCount)
    }

    defaults.set(stored, forKey: storageKey)
  }

  public static func drain() -> [QueuedAnalyticsEvent] {
    guard let defaults else { return [] }

    let stored = defaults.array(forKey: storageKey) as? [[String: Any]] ?? []
    defaults.removeObject(forKey: storageKey)

    return stored.compactMap { entry in
      guard let name = entry["name"] as? String else { return nil }
      let properties = entry["properties"] as? [String: String] ?? [:]
      let timestamp = entry["occurredAt"] as? TimeInterval ?? Date().timeIntervalSince1970
      return QueuedAnalyticsEvent(
        name: name,
        properties: properties,
        occurredAt: Date(timeIntervalSince1970: timestamp)
      )
    }
  }
}
