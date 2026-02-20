//
//  OnboardingHighlightMemoFeature.swift
//  Feature
//
//  Created by 여성일 on 1/13/26.
//

import ComposableArchitecture

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
    
    case route(Route)
    public enum Route: Equatable {
      case back
      case onboardingHighlightGuide
      case onboardingShare
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .send(.route(.back))
        
      case .nextButtonTapped:
        return .send(.route(.onboardingHighlightGuide))
        
      case .skipButtonTapped:
        return .send(.route(.onboardingShare))
        
      case .route:
        return .none
      }
    }
  }
  
  public init() {}
}
