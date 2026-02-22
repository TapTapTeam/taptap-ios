//
//  CategoryFeature.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct CategoryListFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  public struct State: Equatable {
    var categories: [CategoryItem] = []
    var selectedCategory: CategoryItem?
    var isShowingEmptyView: Bool = false
    var addLinkView: Bool = false
    
    public init() {}
  }
  
  public enum Action: Equatable {
    case onAppear
    case categoriesResponse([CategoryItem])
    case categoriesResponseFailed(String)
    case moreCategoryButtonTapped
    case categoryTapped(CategoryItem)
    case addCategoryButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          do {
            let categories = try swiftDataClient.category.fetchCategories()
            await send(.categoriesResponse(categories))
          } catch {
            await send(.categoriesResponseFailed(error.localizedDescription))
          }
        }
        
      case let .categoriesResponse(categories):
        state.categories = categories
        state.selectedCategory = categories.first
        return .none
        
      case .categoriesResponseFailed:
        return .none
        
      case .moreCategoryButtonTapped:
        linkNavigator.push(.myCategory, nil)
        return .none
        
      case let .categoryTapped(category):
        let payload = LinkListPayload(links: [], categoryName: category.categoryName)
        linkNavigator.push(.linkList, payload)
        return .none
        
      case .addCategoryButtonTapped:
        linkNavigator.push(.addCategory, nil)
        return .none
      }
    }
  }
  
  public init() {}
}
