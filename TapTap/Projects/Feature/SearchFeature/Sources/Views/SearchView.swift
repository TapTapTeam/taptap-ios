//
//  SearchView.swift
//  Feature
//
//  Created by 여성일 on 10/19/25.
//

import SwiftData
import SwiftUI

import ComposableArchitecture

import DesignSystem
import Core
import Shared

// MARK: - Properties
public struct SearchView: View {
  @Bindable var store: StoreOf<SearchFeature>
  
  public init(store: StoreOf<SearchFeature>) {
    self.store = store
  }
  
  @FocusState private var isSearchFieldFocused: Bool
}

// MARK: - View
extension SearchView {
  public var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(alignment: .leading, spacing: .zero) {
        TopAppBarSearch(
          text: $store.searchQuery,
          isFocused: $isSearchFieldFocused,
          onBack: { store.send(.backButtonTapped) },
          onSubmit: { store.send(.submit) },
          onClear: { store.send(.clearButtonTapped) }
        )
        
        ScrollView(.vertical, showsIndicators: false) {
          VStack(alignment: .leading, spacing: .zero) {
            if store.searchQuery.isEmpty {
              let recentSearchesExist = !store.recentSearch.searches.isEmpty
              let recentLinksExist = !store.recentLink.recentLinkItem.isEmpty
              
              if !recentSearchesExist && !recentLinksExist {
                EmptySearchView(type: .emptyRecentSearch)
              } else {
                if recentSearchesExist {
                  RecentSearchListView(store: store.scope(state: \.recentSearch, action: \.recentSearch))
                }
                
                if recentSearchesExist && recentLinksExist {
                  Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.divider1)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 12)
                }
                
                if recentLinksExist {
                  RecentLinkListView(store: store.scope(state: \.recentLink, action: \.recentLink))
                }
              }
            } else {
              if store.isSearchSubmitted {
                SearchResultView(
                  store: store.scope(state: \.searchResult, action: \.searchResult)
                )
              } else {
                SearchSuggestionView(store: store.scope(state: \.searchSuggestion, action: \.searchSuggestion))
              }
            }
          }
        }
      }
      .navigationBarHidden(true)
      .contentShape(Rectangle())
      .onTapGesture {
        store.send(.backgroundTapped)
      }
      .onAppear {
        store.send(.onAppear)
        isSearchFieldFocused = true
      }
      .bind($store.isSearchFieldFocused, to: $isSearchFieldFocused)
    }
  }
}

#Preview {
  SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
    SearchFeature()
  }))
}
