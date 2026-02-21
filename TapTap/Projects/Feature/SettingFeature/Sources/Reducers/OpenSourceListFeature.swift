//
//  OpenSourceListFeature.swift
//  Feature
//
//  Created by 이안 on 11/6/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import Shared

@Reducer
public struct OpenSourceListFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  public struct State: Equatable { }
  
  public enum Action: Equatable {
    case backButtonTapped
    case libraryTapped(String)
    
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
        
      case let .libraryTapped(url):
        if let link = URL(string: url) {
          UIApplication.shared.open(link)
        }
        return .none
        
      case .route:
        return .none
      }
    }
  }
  
  public init() {} 
}
