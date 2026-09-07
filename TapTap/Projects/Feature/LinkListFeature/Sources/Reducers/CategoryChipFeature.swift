//
//  CategoryChipFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import ComposableArchitecture

import AnalyticsKit
import Core
import Shared

@Reducer
public struct CategoryChipFeature {
  @Dependency(\.analytics) var analytics
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  public struct State: Equatable {
    var categories: [CategoryItem] = []
    
    var selectedCategory: CategoryItem? = nil
  }
  
  public enum Action: Equatable {
    case onAppear
    case categoriesResponse([CategoryItem])
    case categoriesFailed(String)
    case categoryTapped(CategoryItem)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          do {
            let items = try swiftDataClient.category.fetchCategories()
            await send(.categoriesResponse(items))
          } catch {
            await send(.categoriesFailed(String(describing: error)))
          }
        }
        
      case let .categoriesResponse(items):
        let allCategory = CategoryItem(categoryName: "전체", icon: .init(number: 0))
        state.categories = [allCategory] + items.reversed()

        if let selected = state.selectedCategory,
           let match = state.categories.first(where: { $0.id == selected.id }) {
          state.selectedCategory = match
        } else {
          state.selectedCategory = allCategory
        }
        return .none

      case let .categoriesFailed(message):
        print("Category fetch failed:", message)
        return .none
        
      case let .categoryTapped(category):
        state.selectedCategory = category
        analytics.track(UsageEvent.categoryChipSelected)
        return .none
      }
    }
  }
}
