//
//  OnboardingFinishFeature.swift
//  Feature
//
//  Created by 여성일 on 1/15/26.
//

import ComposableArchitecture

import AnalyticsKit
import Shared

@Reducer
public struct OnboardingFinishFeature {
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
    }
  }
  
  @Dependency(\.userDefaultsClient) var userDefaultsClient
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startButtonTapped:
        analytics.track(UsageEvent.onboardingStepViewed(step: 7, name: "finish"))
        return .run { send in
          try userDefaultsClient.saveOnboardingState()
          await send(.delegate(.onboardingCompleted))
        }
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
