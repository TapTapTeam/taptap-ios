//
//  OriginalNavigation.Reducer.swift
//  OriginalFeature
//
//  Created by 여성일 on 2/22/26.
//

import ComposableArchitecture

struct OriginalNavigationReducer: Reducer {
  typealias State = OriginalArticleFeature.State
  typealias Action = OriginalArticleFeature.Action

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .path(.element(id: _, action: .originalEdit(.route(.back)))):
        state.path.removeLast()
        return .none
        
      default:
        return .none
      }
    }
  }
}
