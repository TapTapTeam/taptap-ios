//
//  AppView.swift
//  TapTap
//
//  Created by 여성일 on 1/12/26.
//

import SwiftUI

import ComposableArchitecture
import LinkNavigator

import Domain
import OnboardingFeature
import Shared

struct AppView {
  @Bindable var store: StoreOf<AppFeature>
  let singleNavigator: SingleLinkNavigator
}

extension AppView: View {
  var body: some View {
    ZStack {
      switch store.state.launchState {
      case .home:
        LinkNavigationView(
          linkNavigator: singleNavigator,
          item: .init(path: Route.home.rawValue)
        )
        .ignoresSafeArea()
      case .splash:
        SplashView()
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
