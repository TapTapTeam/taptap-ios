
//
//  CategorySettingFeature.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import SwiftUI

import ComposableArchitecture

import Shared

@Reducer
public struct CategorySettingFeature {
  @ObservableState
  public struct State: Equatable {
    
  }

  public enum Action: Equatable {
    case dismissButtonTapped
    case addButtonTapped
    case editButtonTapped
    case deleteButtonTapped
  }

  @Dependency(\.dismiss) var dismiss

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dismissButtonTapped:
        return .none
        
      case .addButtonTapped:
        return .none
        
      case .editButtonTapped:
        return .none
        
      case .deleteButtonTapped:
        return .none
      }
    }
  }
  
  public init() {}
}
