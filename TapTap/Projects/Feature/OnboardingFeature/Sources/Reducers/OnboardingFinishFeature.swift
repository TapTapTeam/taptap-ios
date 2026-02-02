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
    
    case moveToHome
  }
  
  @Dependency(\.userDefaultsClient) var userDefaultsClient
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startButtonTapped:
        return .run { send in
          try userDefaultsClient.saveOnboardingState()
          await send(.moveToHome)
        }
      
      case .moveToHome:
        return .none
      }
    }
  }
}
