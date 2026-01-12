//
//  OnboardingStartAppFeature.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import Foundation

import ComposableArchitecture
import LinkNavigator

import Feature

@Reducer
struct OnboardingStartAppFeature {
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  struct State {}
  
  enum Action {
    case startButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startButtonTapped:
        UserDefaults.standard.set(true, forKey: "onboarding")
        navigation.replace([.home], nil)
        return .none
      }
    }
  }
}
