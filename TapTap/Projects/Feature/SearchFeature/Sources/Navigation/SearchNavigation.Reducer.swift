//
//  SearchNavigation.Reducer.swift
//  SearchFeature
//
//  Created by 여성일 on 2/22/26.
//

import ComposableArchitecture

struct SearchNavigationReducer: Reducer {
  typealias State = SearchFeature.State
  typealias Action = SearchFeature.Action

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .recentLink(.delegate(.route(.linkDetail(let item)))):
        return .send(.delegate(.route(.linkDetail(item))))
        
      case .searchResult(.delegate(.route(.linkDetail(let item)))):
        return .send(.delegate(.route(.linkDetail(item))))
                
      case .searchSuggestion(.delegate(.route(.linkDetail(let item)))):
        return .send(.delegate(.route(.linkDetail(item))))
        
      default:
        return .none
      }
    }
  }
}
