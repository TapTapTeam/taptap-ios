//
//  Clipboard.swift
//  Feature
//
//  Created by 홍 on 11/11/25.
//

import SwiftUI

import ComposableArchitecture

extension DependencyValues {
  public var clipboard: ClipboardClient {
    get { self[ClipboardClient.self] }
    set { self[ClipboardClient.self] = newValue }
  }
}

public struct ClipboardClient {
  public var getString: () -> String?
}

extension ClipboardClient: DependencyKey {
  public static let liveValue = Self(
    getString: { UIPasteboard.general.string }
  )
}
