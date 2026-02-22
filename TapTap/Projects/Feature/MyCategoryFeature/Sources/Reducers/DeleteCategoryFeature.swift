//
//  DeleteCategoryFeature.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct DeleteCategoryFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  public struct State: Equatable {
    var categoryGrid = CategoryGridFeature.State(allowsMultipleSelection: true)
    var selectedCategories: Set<CategoryItem> = []
    var isAlert: Bool = false
  }
  
  public enum Action: Equatable {
    case categoryGrid(CategoryGridFeature.Action)
    case deleteButtonTapped
    case backButtonTapped
    case toggleCategorySelection(CategoryItem)
    case confirmAlertDismissed
    case confirmAlertConfirmButtonTapped
    
    case route(Route)
    public enum Route: Equatable {
      case back
    }
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .categoryGrid(.delegate(.toggleCategorySelection(let category))):
        state.selectedCategories.toggle(category)
        return .none
        
      case .categoryGrid(.onAppear):
        return .none
        
      case .categoryGrid(.fetchCategoriesResponse(_)):
        return .none
        
      case .deleteButtonTapped:
        state.isAlert = true
        return .none
        
      case .backButtonTapped:
        return .send(.route(.back))
        
      case let .toggleCategorySelection(category):
        state.selectedCategories.toggle(category)
        return .none
        
      case .categoryGrid(.toggleCategorySelection(_)):
        return .none
        
      case .confirmAlertDismissed:
        state.isAlert = false
        return .none
        
      case .confirmAlertConfirmButtonTapped:
        state.isAlert = false
        return .run { [selectedCategories = state.selectedCategories] send in
          let deletedCount = selectedCategories.count
          for category in selectedCategories {
            try swiftDataClient.category.deleteCategory(category)
          }
          NotificationCenter.default.post(
            name: .categoryDeleted,
            object: ["deletedCount": deletedCount]
          )
          await send(.route(.back))
        }
        
      case .categoryGrid(.fetchCategoriesResponseFailed(_)):
        return .none
        
      case .route:
        return .none
      }
    }
  }
  
  public init() {}
}
