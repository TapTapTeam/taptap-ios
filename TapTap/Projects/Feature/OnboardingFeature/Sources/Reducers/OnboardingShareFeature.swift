//
//  OnboardingShareFeature.swift
//  Feature
//
//  Created by 여성일 on 1/15/26.
//

import ComposableArchitecture

import Shared

@Reducer
public struct OnboardingShareFeature {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
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
      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .nextButtonTapped:
        return .send(.delegate(.route(.onboardingShareGuide)))
        
      case .skipButtonTapped:
        return .send(.delegate(.route(.onboardingFinish)))
      
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
