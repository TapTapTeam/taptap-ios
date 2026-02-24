//
//  OnboardingFinishFeature.swift
//  Feature
//
//  Created by 여성일 on 1/15/26.
//

import ComposableArchitecture

import Shared

@Reducer
public struct OnboardingFinishFeature {
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
