
//
//  CategorySettingFeature.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import SwiftUI

import ComposableArchitecture

import AnalyticsKit
import Shared

@Reducer
public struct CategorySettingFeature {
  @Dependency(\.analytics) var analytics
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
        analytics.track(UsageEvent.categoryMenuTapped(action: "add"))
        return .none
        
      case .editButtonTapped:
        analytics.track(UsageEvent.categoryMenuTapped(action: "edit"))
        return .none
        
      case .deleteButtonTapped:
        analytics.track(UsageEvent.categoryMenuTapped(action: "delete"))
        return .none
      }
    }
  }
  
  public init() {}
}
