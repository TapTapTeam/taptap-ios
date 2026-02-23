//
//  FavoriteSettingFeature.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct FavoriteSettingFeature {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    
    case route(Route)
    public enum Route {
      case back
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .send(.route(.back))
      case .route:
        return .none
      }
    }
  }
  
  public init() {}
}
