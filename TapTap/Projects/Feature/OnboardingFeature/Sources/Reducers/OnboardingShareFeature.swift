//
//  OnboardingShareFeature.swift
//  Feature
//
//  Created by 여성일 on 1/15/26.
//

import ComposableArchitecture

@Reducer
public struct OnboardingShareFeature {
  @ObservableState
  public struct State: Equatable {
    
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case nextButtonTapped
    case skipButtonTapped
    
    case route(Route)
    public enum Route: Equatable {
      case back
      case onboardingShareGuide
      case onboardingFinish
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .send(.route(.back))
        
      case .nextButtonTapped:
        return .send(.route(.onboardingShareGuide))
        
      case .skipButtonTapped:
        return .send(.route(.onboardingFinish))
      
      case .route:
        return .none
      }
    }
  }
}
