//
//  OnboardingFeature.swift
//  Feature
//
//  Created by 여성일 on 1/12/26.
//

import SwiftUI

import ComposableArchitecture

import Shared

@Reducer
public struct OnboardingFeature {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case startButtonTapped
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case onboardingCompleted
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startButtonTapped:
        return .send(.delegate(.route(.onboardingSafariSetting)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
