//
//  SearchResultFeature.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import Foundation
import SwiftData

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
    
    var currentPage: Int = 0
    let pageSize: Int = 50
    var isFetching: Bool = false
    var hasMore: Bool = true
    var totalCount: Int = 0
    
    @Presents var selectBottomSheet: SelectBottomSheetFeature.State?
  }
  
  public enum Action: Equatable {
    case loadSearchResult(String)
    case loadMore
    case searchResponse(response: [ArticleItem], totalCount: Int?)
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
        state.currentPage = 0
        state.hasMore = true
        state.searchResult = []
        state.filteredSearchResult = []
        state.totalCount = 0
        state.isFetching = true
        
        return .run { [pageSize = state.pageSize] send in
          do {
            let response = try swiftDataClient.link.searchLinks(query: query, limit: pageSize, offset: 0)
            let descriptor = FetchDescriptor<TapTapSchemaV2.ArticleItem>(predicate: #Predicate { $0.title.localizedStandardContains(query) })
            let totalCount = try swiftDataClient.link.fetchLinksCount(predicate: descriptor.predicate)
            await send(.searchResponse(response: response, totalCount: totalCount))
          } catch {
            await send(.searchResponse(response: [], totalCount: 0))
          }
        }
        
      case .loadMore:
        guard !state.isFetching, state.hasMore else { return .none }
        state.isFetching = true
        state.currentPage += 1
        
        return .run { [query = state.query, page = state.currentPage, pageSize = state.pageSize] send in
          do {
            let response = try swiftDataClient.link.searchLinks(query: query, limit: pageSize, offset: page * pageSize)
            await send(.searchResponse(response: response, totalCount: nil))
          } catch {
            await send(.searchResponse(response: [], totalCount: nil))
          }
        }
        
      case let .searchResponse(item, totalCount):
        state.isFetching = false
        if let totalCount {
          state.totalCount = totalCount
        }
        
        if item.isEmpty || item.count < state.pageSize {
          state.hasMore = false
        }
        
        let existingIDs = Set(state.searchResult.map { $0.id })
        let newItems = item.filter { !existingIDs.contains($0.id) }
        state.searchResult.append(contentsOf: newItems)
        
        if state.selectedCategoryTitle == "카테고리" || state.selectedCategoryTitle == "전체" {
          state.filteredSearchResult = state.searchResult
        } else {
          state.filteredSearchResult = state.searchResult.filter { link in
            link.category?.categoryName == state.selectedCategoryTitle
          }
        }
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

