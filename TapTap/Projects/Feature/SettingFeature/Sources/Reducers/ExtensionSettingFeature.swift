//
//  ExtensionSettingFeature.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import ComposableArchitecture

import Core
import AnalyticsKit
import Shared

@Reducer
public struct ExtensionSettingFeature {
  @Dependency(\.analytics) var analytics
  @ObservableState
  public struct State: Equatable {
    var currentPage: Int = 1
    public init() {}
  }
  
  public enum Action: Equatable {
    case settingButtonTapped
    case backButtonTapped
    case naviPush
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .settingButtonTapped:
        analytics.track(UsageEvent.settingRowTapped(row: "open_ios_settings"))
        return .none
        
      case .naviPush:
        analytics.track(UsageEvent.safariGuideViewed)
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
