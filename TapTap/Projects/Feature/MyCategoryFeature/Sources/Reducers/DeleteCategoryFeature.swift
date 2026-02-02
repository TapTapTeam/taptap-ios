//
//  DeleteCategoryFeature.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture
import LinkNavigator

import Domain
import Shared

@Reducer
public struct DeleteCategoryFeature {
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  public struct State {
    var topAppBar = TopAppBarDefaultRightIconxFeature.State(title: "카테고리 삭제하기")
    var categoryGrid = CategoryGridFeature.State(allowsMultipleSelection: true)
    var selectedCategories: Set<CategoryItem> = []
    var isAlert: Bool = false
  }
  
  public enum Action {
    case categoryGrid(CategoryGridFeature.Action)
    case deleteButtonTapped
    case toggleCategorySelection(CategoryItem)
    case topAppBar(TopAppBarDefaultRightIconxFeature.Action)
    case confirmAlertDismissed
    case confirmAlertConfirmButtonTapped
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
      case let .toggleCategorySelection(category):
        state.selectedCategories.toggle(category)
        return .none
      case .categoryGrid(.toggleCategorySelection(_)):
        return .none
      case .topAppBar(_):
        return .run { _ in await navigation.pop() }
      case .confirmAlertDismissed:
        state.isAlert = false
        return .none
      case .confirmAlertConfirmButtonTapped:
        state.isAlert = false
        return .run { [selectedCategories = state.selectedCategories] _ in
          let deletedCount = selectedCategories.count
          for category in selectedCategories {
            try swiftDataClient.deleteCategory(category)
          }
          NotificationCenter.default.post(
            name: .categoryDeleted,
            object: ["deletedCount": deletedCount]
          )
          await navigation.pop()
        }
      }
    }
  }
  
  public init() {}
}
