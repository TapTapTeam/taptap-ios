//
//  AnalyticsProviding.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

public protocol AnalyticsProviding: Sendable {
  var identifier: String { get }

  @discardableResult
  func start() -> Bool

  func track(_ event: AnalyticsEvent)
  func setUserProperty(_ property: AnalyticsUserProperty)
  func setUserID(_ userID: String?)

  func setCollectionEnabled(_ isEnabled: Bool)
}
