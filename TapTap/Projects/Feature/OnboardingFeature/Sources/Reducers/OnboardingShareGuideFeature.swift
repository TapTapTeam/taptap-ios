//
//  OnboardingShareGuideFeature.swift
//  Feature
//
//  Created by 여성일 on 1/15/26.
//

import ComposableArchitecture

import Shared

@Reducer
public struct OnboardingShareGuideFeature {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case completeButtonTapped
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .completeButtonTapped:
        return .send(.delegate(.route(.onboardingFinish)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
