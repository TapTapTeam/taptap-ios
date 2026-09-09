//
//  OnboardingHighlightMemoFeature.swift
//  Feature
//
//  Created by 여성일 on 1/13/26.
//

import ComposableArchitecture

import AnalyticsKit
import Shared

@Reducer
public struct OnboardingHighlightMemoFeature {
  @Dependency(\.analytics) var analytics
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case onAppear
    case backButtonTapped
    case nextButtonTapped
    case skipButtonTapped
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        analytics.track(UsageEvent.onboardingStepViewed(step: 4, name: "highlight_memo"))
        return .none

      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .nextButtonTapped:
        return .send(.delegate(.route(.onboardingHighlightGuide)))
        
      case .skipButtonTapped:
        analytics.track(UsageEvent.onboardingSkipped(step: 4))
        return .send(.delegate(.route(.onboardingShare)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
