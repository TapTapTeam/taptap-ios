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
    case path(StackActionOf<Path>)
    case startButtonTapped
    
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

      case .delegate, .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    
    OnboardingNavigationReducer()
  }

  public init() {}
}
