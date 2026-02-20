//
//  OnboardingFinishFeature.swift
//  Feature
//
//  Created by 여성일 on 1/15/26.
//

import ComposableArchitecture

@Reducer
public struct OnboardingFinishFeature {
  @ObservableState
  public struct State: Equatable {
  }
  
  public enum Action: Equatable {
    case startButtonTapped
    
    case route(Route)
    public enum Route {
      case home
    }
  }
  
  @Dependency(\.userDefaultsClient) var userDefaultsClient
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startButtonTapped:
        return .run { send in
          try userDefaultsClient.saveOnboardingState()
          await send(.route(.home))
        }
        
      case .route:
        return .none
      }
    }
  }
}
