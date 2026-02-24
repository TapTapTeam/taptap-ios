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
  
  @ObservableState
  public struct State: Equatable {
    var categories: [CategoryItem] = []
    var selectedCategory: CategoryItem?
    var isShowingEmptyView: Bool = false
    var addLinkView: Bool = false
    
    public init() { }
  }
  
  public enum Action: Equatable {
    case onAppear
    case categoriesResponse([CategoryItem])
    case categoriesResponseFailed(String)
    case moreCategoryButtonTapped
    case categoryTapped(CategoryItem)
    case addCategoryButtonTapped
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
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
        return .send(.delegate(.route(.myCategoryCollection)))
        
      case let .categoryTapped(category):
        return .send(.delegate(.route(.linkList(initCategory: category.categoryName))))
        
      case .addCategoryButtonTapped:
        return .send(.delegate(.route(.addCategory)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
