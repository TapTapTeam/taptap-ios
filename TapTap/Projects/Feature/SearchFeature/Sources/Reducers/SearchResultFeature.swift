//
//  SearchResultFeature.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import Foundation

import ComposableArchitecture

import DesignSystem
import Core
import Shared

@Reducer
public struct SearchResultFeature {
  @ObservableState
  public struct State: Equatable {
    var searchResult: [ArticleItem] = []
    var filteredSearchResult: [ArticleItem] = []
    var query: String = ""
    var selectedCategoryTitle: String = "카테고리"
    var filteredCategories: [CategoryItem] = []
    var originalSearchResults: [ArticleItem] = []
    
    @Presents var selectBottomSheet: SelectBottomSheetFeature.State?
  }
  
  public enum Action: Equatable {
    case loadSearchResult(String)
    case searchResponse([ArticleItem])
    case linkCardTapped(ArticleItem)
    case categoryButtonTapped
    
    case selectBottomSheet(PresentationAction<SelectBottomSheetFeature.Action>)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.uuid) var uuid
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .loadSearchResult(let query):
        state.query = query
        return .run { send in
          let response = try swiftDataClient.link.searchLinks(query: query)
          await send(.searchResponse(response))
        }
        
      case .searchResponse(let item):
        state.searchResult = item
        state.filteredSearchResult = item
        state.selectedCategoryTitle = "카테고리"
        return .none
        
      case .linkCardTapped(let item):
        return .send(.delegate(.route(.linkDetail(item))))
        
      case .categoryButtonTapped:
        let categoriesFromResults = state.searchResult.compactMap { $0.category }
        var uniqueCategories = Array(Set(categoriesFromResults))
        uniqueCategories.sort { $0.categoryName < $1.categoryName }
        
        var categoryProps = uniqueCategories.map { CategoryProps(id: $0.id, title: $0.categoryName) }
        
        let allCategory = CategoryProps(id: uuid(), title: "전체")
        categoryProps.insert(allCategory, at: 0)
        
        let allCategories = IdentifiedArray(uniqueElements: categoryProps)
        
        state.selectBottomSheet = SelectBottomSheetFeature.State(
          categories: allCategories,
          selectedCategory: state.selectedCategoryTitle == "카테고리" ? "전체" : state.selectedCategoryTitle
        )
        return .none
        
      case .selectBottomSheet(.presented(.delegate(.categorySelected(let category)))):
        if let category = category {
          var selectedCategoryTitle: String {
            category == "전체" ? "카테고리" : category
          }
          state.selectedCategoryTitle = selectedCategoryTitle
          
          if category == "전체" {
            state.filteredSearchResult = state.searchResult
          } else {
            state.filteredSearchResult = state.searchResult.filter { link in
              link.category?.categoryName == category
            }
          }
        }
        return .none
        
      case .selectBottomSheet:
        return .none
        
      case .delegate:
        return .none
      }
    }
    .ifLet(\.$selectBottomSheet, action: \.selectBottomSheet) {
      SelectBottomSheetFeature()
    }
  }
  
  public init() {}
}

