//
//  PolicyDetailFeature.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import Foundation

import ComposableArchitecture
import LinkNavigator

import Core
import Shared

@Reducer
public struct PolicyDetailFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
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
