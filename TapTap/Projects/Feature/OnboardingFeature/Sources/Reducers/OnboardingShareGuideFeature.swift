//
//  OnboardingShareGuideFeature.swift
//  Feature
//
//  Created by 여성일 on 1/15/26.
//

import ComposableArchitecture

@Reducer
public struct OnboardingShareGuideFeature {
  @ObservableState
  public struct State: Equatable {
    
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case completeButtonTapped
    
    case route(Route)
    public enum Route: Equatable {
      case back
      case onboardingFinish
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .send(.route(.back))
        
      case .completeButtonTapped:
        return .send(.route(.onboardingFinish))
        
      case .route:
        return .none
      }
    }
  }
}
