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
      default:
        return .none
      }
    }
  }
}
