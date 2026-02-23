//
//  LinkDetailCoordinator.swift
//  TapTap
//
//  Created by 여성일 on 2/24/26.
//

import ComposableArchitecture

struct LinkDetailCoordinator: Reducer {
  typealias State = AppCoordinator.State
  typealias Action = AppCoordinator.Action
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .path(.element(id: _, action: .linkDetail(.delegate(.route(let route))))):
        switch route {
        case .originalArticle(let article):
          state.path.append(.originalArticle(.init(articleItem: article)))
          return .none
        }
      default:
        return .none
      }
    }
  }
}
