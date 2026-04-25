//
//  OnboardingHighlightMemoFeature.swift
//  Feature
//
//  Created by 여성일 on 1/13/26.
//

import ComposableArchitecture

import Shared

@Reducer
public struct OnboardingHighlightMemoFeature {
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
        return .send(.delegate(.route(.onboardingHighlightGuide)))
        
      case .skipButtonTapped:
        return .send(.delegate(.route(.onboardingShare)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
