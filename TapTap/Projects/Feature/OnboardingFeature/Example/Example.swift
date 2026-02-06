//
//  Example.swift
//  HomeFeature
//
//  Created by 여성일 on 1/25/26.
//

import SwiftUI

import ComposableArchitecture
import OnboardingFeature

@main
struct Example: App {
  private let store = Store(initialState: OnboardingFeature.State()) {
    OnboardingFeature()
  }
  
  var body: some Scene {
    WindowGroup {
      OnboardingView(store: store)
    }
  }
}
