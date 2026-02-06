//
//  OnboardingFeature.swift
//  Feature
//
//  Created by 여성일 on 1/12/26.
//

import SwiftUI

import ComposableArchitecture

@Reducer
public struct OnboardingFeature {
  @ObservableState
  public struct State: Equatable {
    var path: StackState<Path.State> = .init()
    
    public init() {}
  }
  
  public enum Action: Equatable {
    case startButtonTapped
    case path(StackActionOf<Path>)
    
    case delegate(Delegate)
    
    public enum Delegate: Equatable {
        case onboardingCompleted
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startButtonTapped:
        state.path.append(.onboardingSafariSetting(.init()))
        return .none
      
      case .path(.element(id: _, action: .onboardingSafariSetting(.moveToOnboardingHighlightMemo))):
        state.path.append(.onboardingHighlightMemo(.init()))
        return .none
      
      case .path(.element(id: _, action: .onboardingHighlightMemo(.moveToOnboardingHighlightGuide))):
        state.path.append(.onboardingHighlightGuide(.init()))
        return .none
        
      case .path(.element(id: _, action: .onboardingHighlightMemo(.moveToOnboardingShare))):
        state.path.append(.onboardingShare(.init()))
        return .none
        
      case .path(.element(id: _, action: .onboardingHighlightGuide(.moveToOnboardingShare))):
        state.path.append(.onboardingShare(.init()))
        return .none
      
      case .path(.element(id: _, action: .onboardingHighlightGuide(.backButtonTapped))):
        state.path.removeLast()
        return .none
        
      case .path(.element(id: _, action: .onboardingShare(.moveToOnboardingShareGuide))):
        state.path.append(.onboardingShareGuide(.init()))
        return .none
        
      case .path(.element(id: _, action: .onboardingShare(.moveToOnboardingFinish))):
        state.path.append(.onboardingFinish(.init()))
        return .none
        
      case .path(.element(id: _, action: .onboardingShareGuide(.moveToOnboardingFinish))):
        state.path.append(.onboardingFinish(.init()))
        return .none
        
      case .path(.element(id: _, action: .onboardingFinish(.moveToHome))):
        return .send(.delegate(.onboardingCompleted))
      
      case .path:
        return .none
        
      case .delegate:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }

  public init() {}
  
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case onboardingSafariSetting(OnboardingSafariSettingFeature)
    case onboardingHighlightMemo(OnboardingHighlightMemoFeature)
    case onboardingHighlightGuide(OnboardingHighlightGuideFeature)
    case onboardingShare(OnboardingShareFeature)
    case onboardingShareGuide(OnboardingShareGuideFeature)
    case onboardingFinish(OnboardingFinishFeature)
  }
}
