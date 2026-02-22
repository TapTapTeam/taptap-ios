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
  @Dependency(\.linkNavigator) var linkNavigator
  
  public struct State: Equatable {
    var categories: [CategoryItem] = []
  }
  
  public enum Action: Equatable {
    case onAppear
    case fetchCategoriesResponse([CategoryItem])
    case fetchCategoriesResponseFailed(String)
    case categoryTapped(CategoryItem)
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var navigation
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .categoryTapped(category):
        let payload = LinkListPayload(links: [], categoryName: category.categoryName)
        linkNavigator.push(.linkList, payload)
        return .none
        
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
      }
    }
  }
  
  public init() {}
}
