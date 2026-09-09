//
//  FavoriteSettingFeature.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import ComposableArchitecture

import Core
import AnalyticsKit
import Shared

@Reducer
public struct FavoriteSettingFeature {
  @Dependency(\.analytics) var analytics
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case onAppear
    case backButtonTapped
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        analytics.track(UsageEvent.screenViewed(.settingFavorite))
        return .none

      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
