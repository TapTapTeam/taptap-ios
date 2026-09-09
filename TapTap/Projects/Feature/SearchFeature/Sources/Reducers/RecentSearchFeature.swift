//
//  RecentSearchFeature.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import Foundation

import ComposableArchitecture

import AnalyticsKit
import Shared

@Reducer
public struct RecentSearchFeature {
  @Dependency(\.analytics) var analytics
  @ObservableState
  public struct State: Equatable {
    var searches: IdentifiedArrayOf<SearchTerm> = []
  }
  
  public enum Action: Equatable {
    case onAppear
    case loadRecentSearches([String])
    case add(String)
    case del(id: SearchTerm.ID)
    case clear
    case chipTapped(String)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case chipTapped(String)
    }
  }
  
  @Dependency(\.recentSearchClient) var recentSearchClient
  @Dependency(\.uuid) var uuid
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let recentSearchItems = try await recentSearchClient.load()
          await send(.loadRecentSearches(recentSearchItems))
        }
        
      case .loadRecentSearches(let term):
        state.searches = IdentifiedArray(uniqueElements: term.map { SearchTerm(id: uuid(), text: $0)})
        return .none
        
      case .add(let term):
        return .run { send in
          let updateSearches = try await recentSearchClient.add(term)
          await send(.loadRecentSearches(updateSearches))
        }
        
      case .del(let id):
        guard let deleteItem = state.searches[id: id] else { return .none }
        analytics.track(UsageEvent.recentSearchDeleted(isAll: false))
        return .run { send in
          let updateSearches = try await recentSearchClient.remove(deleteItem.text)
          await send(.loadRecentSearches(updateSearches))
        }
        
      case .clear:
        analytics.track(UsageEvent.recentSearchDeleted(isAll: true))
        return .run { send in
          let updateSearches = try await recentSearchClient.clear()
          await send(.loadRecentSearches(updateSearches))
        }
        
      case .chipTapped(let term):
        return .send(.delegate(.chipTapped(term)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
