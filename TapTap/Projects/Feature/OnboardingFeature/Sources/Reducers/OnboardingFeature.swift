//
//  OnboardingFeature.swift
//  Feature
//
//  Created by 여성일 on 1/12/26.
//

import SwiftUI

import ComposableArchitecture

import AnalyticsKit
import Shared

@Reducer
public struct OnboardingFeature {
  @Dependency(\.analytics) var analytics

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case startButtonTapped
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case onboardingCompleted
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startButtonTapped:
        analytics.track(UsageEvent.onboardingStepViewed(step: 1, name: "intro"))
        return .send(.delegate(.route(.onboardingSafariSetting)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
