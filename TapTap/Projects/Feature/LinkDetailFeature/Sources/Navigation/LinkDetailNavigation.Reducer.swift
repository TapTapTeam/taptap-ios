//
//  LinkDetailNavigation.Reducer.swift
//  LinkDetailFeature
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

struct LinkDetailNavigationReducer: Reducer {
  typealias State = LinkDetailFeature.State
  typealias Action = LinkDetailFeature.Action

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .originalArticleLoadingCompleted:
        state.isLoadingOriginalArticle = false
        state.originalArticleProgress = 0.0
        return .send(.delegate(.route(.originalArticle(state.link))))
        
      default:
        return .none
      }
    }
  }
}
