//
//  MyCategoryGridFeature.swift
//  Feature
//
//  Created by 홍 on 10/31/25.
//

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct MyCategoryGridFeature {
  public struct State: Equatable {
    var categories: [CategoryItem] = []
  }
  
  public enum Action: Equatable {
    case onAppear
    case fetchCategoriesResponse([CategoryItem])
    case fetchCategoriesResponseFailed(String)
    case categoryTapped(CategoryItem)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .categoryTapped(category):
        return .send(.delegate(.route(.linkList(initCategory: category.categoryName))))
        
      case .onAppear:
        return .run { send in
          do {
            let categories = try swiftDataClient.category.fetchCategories()
            await send(.fetchCategoriesResponse(categories))
          } catch {
            await send(.fetchCategoriesResponseFailed(error.localizedDescription))
          }
        }
        
      case let .fetchCategoriesResponse(categories):
        state.categories = categories
        return .none
        
      case .fetchCategoriesResponseFailed:
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
