//
//  AnalyticsConfiguration.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

/// 키를 어디서 읽고, 키가 없을 때 어떻게 굴러갈지를 한 곳에 모은다.
///
/// 키는 저장소에 커밋하지 않는다. 탭탭은 이미 `Tuist/Config/Project.xcconfig`가
/// `.gitignore`(`*.xcconfig`)에 걸려 있어 서명 값들을 그렇게 다루고 있으므로 같은 통로를 쓴다.
/// xcconfig → Info.plist(`$(AMPLITUDE_API_KEY)`) → 여기.
///
/// - Note: Firebase는 키가 아니라 `GoogleService-Info.plist` 파일을 번들에서 찾는다.
///   그 파일도 커밋하지 않는다(`.gitignore`에 추가).
public struct AnalyticsConfiguration: Sendable {
  public let amplitudeAPIKey: String?
  public let hasFirebaseConfigFile: Bool

  /// 릴리즈 빌드가 아닐 때는 콘솔 프로바이더를 함께 붙여 "무엇이 찍히는지"를 눈으로 본다.
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

  /// 앱 번들에서 읽어온 설정.
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
  /// xcconfig 변수가 비어 있으면 Info.plist에는 빈 문자열이 남는다 — 그건 "키 없음"으로 본다.
  func nonEmptyString(forInfoDictionaryKey key: String) -> String? {
    guard let value = object(forInfoDictionaryKey: key) as? String else { return nil }
    let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? nil : trimmed
  }
}
