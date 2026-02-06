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
    
    case moveToOnboardingFinish
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { _ in
          await dismiss()
        }
        
      case .completeButtonTapped:
        return .send(.moveToOnboardingFinish)
        
      case .moveToOnboardingFinish:
        return .none
      }
    }
  }
}
