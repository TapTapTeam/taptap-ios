//
//  AppView.swift
//  TapTap
//
//  Created by 여성일 on 1/12/26.
//

import SwiftUI

import ComposableArchitecture

import Core
import OnboardingFeature
import Shared

struct AppView {
  @Bindable var store: StoreOf<AppFeature>
}

extension AppView: View {
  var body: some View {
    ZStack {
      switch store.state.launchState {
      case .splash:
        SplashView()
        
      case .home:
        if let coordinatorStore = store.scope(state: \.appCoordinator, action: \.appCoordinator) {
          AppCoordinatorView(store: coordinatorStore)
            .ignoresSafeArea()
        }

      case .onboarding:
        if let onboardingStore = store.scope(state: \.onboarding, action: \.onboarding) {
          OnboardingView(store: onboardingStore)
            .ignoresSafeArea()
        }
      }
    }
    .alert($store.scope(state: \.alert, action: \.alert))
    .animation(.easeInOut(duration: 0.3), value: store.state.launchState)
    .onAppear {
      store.send(.onAppear)
    }
  }
}
