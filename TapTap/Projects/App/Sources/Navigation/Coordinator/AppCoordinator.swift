//
//  AppCoordinator.swift
//  TapTap
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

import AddLinkFeature
import HomeFeature
import SettingFeature
import OnboardingFeature

@Reducer
public struct AppCoordinator {
  public struct State: Equatable {
    var path = StackState<Path.State>()
    var home = HomeFeature.State()
  }
  
  public enum Action: Equatable {
    case path(StackActionOf<Path>)
    case home(HomeFeature.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.home, action: \.home) { HomeFeature() }
    Reduce { state, action in
      switch action {
      case .home(.delegate(.route(.setting))):
        state.path.append(.setting(.init()))
        return .none
        
//      case .home(.delegate(.route(.addLink))):
//        state.path.append(.addLink(.init()))
//        return .none

      case .home, .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    
    SettingCoordinatorReducer()
  }

  public init() {}
}
