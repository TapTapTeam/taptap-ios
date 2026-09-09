//
//  AnalyticsConfiguration.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

public struct AnalyticsConfiguration: Sendable {
  public let amplitudeAPIKey: String?
  public let hasFirebaseConfigFile: Bool

  public let isDebugLoggingEnabled: Bool

  public init(
    amplitudeAPIKey: String?,
    hasFirebaseConfigFile: Bool,
    isDebugLoggingEnabled: Bool
  ) {
    self.amplitudeAPIKey = amplitudeAPIKey
    self.hasFirebaseConfigFile = hasFirebaseConfigFile
    self.isDebugLoggingEnabled = isDebugLoggingEnabled
  }

  public static func fromMainBundle(_ bundle: Bundle = .main) -> AnalyticsConfiguration {
    #if DEBUG
    let isDebug = true
    #else
    let isDebug = false
    #endif

    return AnalyticsConfiguration(
      amplitudeAPIKey: bundle.nonEmptyString(forInfoDictionaryKey: Self.amplitudeKeyName),
      hasFirebaseConfigFile: bundle.path(forResource: "GoogleService-Info", ofType: "plist") != nil,
      isDebugLoggingEnabled: isDebug
    )
  }

  static let amplitudeKeyName = "AMPLITUDE_API_KEY"
}

private extension Bundle {
  func nonEmptyString(forInfoDictionaryKey key: String) -> String? {
    guard let value = object(forInfoDictionaryKey: key) as? String else { return nil }
    let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? nil : trimmed
  }
}
