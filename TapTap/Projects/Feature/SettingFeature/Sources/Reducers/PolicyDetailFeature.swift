//
//  PolicyDetailFeature.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import Foundation

import ComposableArchitecture

import Core
import AnalyticsKit
import Shared

@Reducer
public struct PolicyDetailFeature {
  @Dependency(\.analytics) var analytics
  @ObservableState
  public struct State: Equatable {
    public var title: String
    public var text: String
    
    public init(title: String, text: String) {
      self.title = title
      self.text = text
    }
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
        analytics.track(UsageEvent.screenViewed(.settingPolicy))
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
