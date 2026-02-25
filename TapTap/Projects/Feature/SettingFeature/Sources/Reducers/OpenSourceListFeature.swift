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
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case libraryTapped(String)
    
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
        
      case let .libraryTapped(url):
        if let link = URL(string: url) {
          UIApplication.shared.open(link)
        }
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {} 
}
