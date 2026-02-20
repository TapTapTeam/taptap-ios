//
//  OnboardingSafariSettingFeature.swift
//  Feature
//
//  Created by 여성일 on 1/12/26.
//

import ComposableArchitecture

@Reducer
public struct OnboardingSafariSettingFeature {
  @ObservableState
  public struct State: Equatable {
    var isAlert: Bool = false
    var hasOpenedSettings: Bool = false
    
    public init() {}
  }
  
  public enum Action: Equatable {
    case onAppear
    case nextButtonTapped
    case alertCancelButtonTapped
    case alertConfirmButtonTapped
    case settingsOpened
    
    case route(Route)
    public enum Route: Equatable {
      case onboardingHighlightMemo
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.hasOpenedSettings = false
        return .none
        
      case .settingsOpened:
        state.hasOpenedSettings = true
        return .none
        
      case .nextButtonTapped:
        if !state.hasOpenedSettings {
          state.isAlert = true
          return .none
        }
        return .send(.route(.onboardingHighlightMemo))
        
      case .alertCancelButtonTapped:
        state.isAlert = false
        return .none
        
      case .alertConfirmButtonTapped:
        state.isAlert = false
        return .send(.route(.onboardingHighlightMemo))
        
      case .route:
        return .none
      }
    }
  }
  
  public init() {}
}
