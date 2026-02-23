//
//  SearchFeature.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import Foundation

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct SearchFeature {
  @ObservableState
  public struct State: Equatable {
    var searchQuery: String = ""
    var isSearchFieldFocused: Bool = false
    var isSearchSubmitted: Bool = false

    var recentSearch: RecentSearchFeature.State = .init()
    var recentLink: RecentLinkFeature.State = .init()
    var searchResult: SearchResultFeature.State = .init()
    var searchSuggestion: SearchSuggestionFeature.State = .init()
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)

    case onAppear
    case backgroundTapped
    case backButtonTapped
    case submit
    case clearButtonTapped

    case recentSearch(RecentSearchFeature.Action)
    case recentLink(RecentLinkFeature.Action)
    case searchResult(SearchResultFeature.Action)
    case searchSuggestion(SearchSuggestionFeature.Action)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(Route)
    }
    
    public enum Route: Equatable {
      case back
      case linkDetail(ArticleItem)
    }
  }

  public enum CancelID { case searchDebounce }

  public var body: some ReducerOf<Self> {
    Scope(state: \.recentSearch, action: \.recentSearch) { RecentSearchFeature() }
    Scope(state: \.recentLink, action: \.recentLink) { RecentLinkFeature() }
    Scope(state: \.searchResult, action: \.searchResult) { SearchResultFeature() }
    Scope(state: \.searchSuggestion, action: \.searchSuggestion) { SearchSuggestionFeature() }

    BindingReducer()
      .onChange(of: \.searchQuery) { _, newValue in
        Reduce { state, _ in
          state.isSearchSubmitted = false
          state.searchSuggestion.searchText = newValue

          let q = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
          guard !q.isEmpty else {
            return .cancel(id: CancelID.searchDebounce)
          }

          return .run { send in
            await send(.searchSuggestion(.loadSuggestionItem(q)))
          }
          .debounce(id: CancelID.searchDebounce, for: 0.5, scheduler: RunLoop.main)
          .cancellable(id: CancelID.searchDebounce, cancelInFlight: true)
        }
      }

    Reduce { state, action in
      switch action {
      case .onAppear:
        state.isSearchFieldFocused = true
        return .merge(
          .send(.recentSearch(.onAppear)),
          .send(.recentLink(.onAppear))
        )

      case .backgroundTapped:
        state.isSearchFieldFocused = false
        return .none

      case .clearButtonTapped:
        state.searchQuery = ""
        state.isSearchSubmitted = false
        state.searchSuggestion.searchText = ""
        return .cancel(id: CancelID.searchDebounce)

      case .submit:
        let q = state.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return .none }

        state.isSearchSubmitted = true
        state.isSearchFieldFocused = false

        return .run { send in
          await send(.recentSearch(.add(q)))
          await send(.searchResult(.loadSearchResult(q)))
        }

      case .recentSearch(.delegate(let action)):
        switch action {
        case .chipTapped(let term):
          state.searchQuery = term
          state.isSearchSubmitted = true
          state.isSearchFieldFocused = false
          return .run { send in
            await send(.searchResult(.loadSearchResult(term)))
          }
        }

      case .recentSearch, .recentLink, .searchResult, .searchSuggestion, .binding, .delegate:
        return .none
        
      default:
        return .none
      }
    }
    
    SearchNavigationReducer()
  }
  
  public init() {}
}
