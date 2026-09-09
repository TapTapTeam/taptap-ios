//
//  AnalyticsServiceTests.swift
//  AnalyticsKitTests
//
//  Created by 홍 on 9/5/26.
//

import XCTest

@testable import AnalyticsKit

final class AnalyticsServiceTests: XCTestCase {
  func test_이벤트는_붙어있는_모든_프로바이더로_간다() {
    let first = RecordingProvider(identifier: "first")
    let second = RecordingProvider(identifier: "second")
    let service = AnalyticsService(providers: [first, second])

    service.track(ConversionEvent.onboardingCompleted.event)

    XCTAssertEqual(first.trackedNames, ["onboarding_complete"])
    XCTAssertEqual(second.trackedNames, ["onboarding_complete"])
  }

  func test_프로바이더가_없어도_아무_일도_일어나지_않는다() {
    let service = AnalyticsService(providers: [])

    service.start()
    service.track(UsageEvent.screenViewed(.home).event)
    service.setUserProperty(.hasOnboarded(true))
  }

  func test_키가_없으면_프로바이더가_붙지_않는다() {
    let configuration = AnalyticsConfiguration(
      amplitudeAPIKey: nil,
      hasFirebaseConfigFile: false,
      isDebugLoggingEnabled: false
    )

    let service = AnalyticsService(configuration: configuration)
    service.start()
    service.track(ConversionEvent.highlightCreated.event)
  }

  func test_Amplitude는_키가_없으면_시작하지_않는다() {
    XCTAssertFalse(AmplitudeAnalyticsProvider(apiKey: nil).start())
  }

  func test_유저프로퍼티_이름과_구간() {
    let provider = RecordingProvider(identifier: "p")
    let service = AnalyticsService(providers: [provider])

    service.setUserProperty(.savedLinkCount(23))

    XCTAssertEqual(provider.properties.first?.name, "saved_link_count")
    XCTAssertEqual(provider.properties.first?.value, .string("20-49"))
  }
}

private final class RecordingProvider: AnalyticsProviding, @unchecked Sendable {
  let identifier: String

  private(set) var trackedNames: [String] = []
  private(set) var properties: [AnalyticsUserProperty] = []

  init(identifier: String) {
    self.identifier = identifier
  }

  func start() -> Bool { true }

  func track(_ event: AnalyticsEvent) {
    trackedNames.append(event.name)
  }

  func setUserProperty(_ property: AnalyticsUserProperty) {
    properties.append(property)
  }

  func setUserID(_ userID: String?) {}
  func setCollectionEnabled(_ isEnabled: Bool) {}
}
