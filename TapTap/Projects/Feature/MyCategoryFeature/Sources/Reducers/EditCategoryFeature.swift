//
//  EditCategoryFeature.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct EditCategoryFeature {
  @ObservableState
  public struct State: Equatable {
    var categoryGrid = CategoryGridFeature.State(allowsMultipleSelection: false)
    var selectedCategory: CategoryItem?
    var showToast: Bool = false
    var toastMessage: String = ""
  }
  
  public enum Action: Equatable {
    case categoryGrid(CategoryGridFeature.Action)
    case cancelButtonTapped
    case editButtonTapped
    case backButtonTapped
    case showToast(String)
    case onAppear
    case hideToast

    case route(Route)
    public enum Route: Equatable {
      case back
      case editCategoryIconName(CategoryItem)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.selectedCategory = nil
        return .none
        
      case .categoryGrid(.delegate(.toggleCategorySelection(let category))):
        if state.selectedCategory == category {
          state.selectedCategory = nil
        } else {
          state.selectedCategory = category
        }
        return .none
        
      case .categoryGrid(.onAppear):
        return .none
        
      case .categoryGrid(.fetchCategoriesResponse(_)):
        return .none
        
      case .categoryGrid(.toggleCategorySelection(_)):
        return .none
        
      case .cancelButtonTapped:
        return .send(.route(.back))
        
      case .editButtonTapped:
        guard let category = state.selectedCategory else { return .none }
        return .send(.route(.editCategoryIconName(category)))
      
      case .backButtonTapped:
        return .send(.route(.back))
        
      case .showToast(let message):
        state.showToast = true
        state.toastMessage = message
        return .run { send in
          try await Task.sleep(for: .seconds(2))
          await send(.hideToast)
        }
        
      case .hideToast:
        state.showToast = false
        state.toastMessage = ""
        return .none
        
      case .categoryGrid(.fetchCategoriesResponseFailed(_)):
        return .none
        
      case .route:
        return .none
      }
    }
  }
  
  public init() {}
}
