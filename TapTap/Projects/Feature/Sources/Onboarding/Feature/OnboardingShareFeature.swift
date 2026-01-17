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
    
    case moveToOnboardingShareGuide
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
        
      case .nextButtonTapped:
        return .send(.moveToOnboardingShareGuide)
        
      case .skipButtonTapped:
        return .send(.moveToOnboardingFinish)
        
      case .moveToOnboardingShareGuide:
        return .none
        
      case .moveToOnboardingFinish:
        return .none
      }
    }
  }
}
