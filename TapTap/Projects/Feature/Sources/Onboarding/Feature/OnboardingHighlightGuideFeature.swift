//
//  OnboardingHighlightGuideFeature.swift
//  Feature
//
//  Created by 여성일 on 1/13/26.
//

import ComposableArchitecture

@Reducer
public struct OnboardingHighlightGuideFeature {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case nextButtonTapped
    
    case moveToOnboardingShare
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
        return .send(.moveToOnboardingShare)
      
      case .moveToOnboardingShare:
        return .none
      }
    }
  }
  
  public init() {}
}
