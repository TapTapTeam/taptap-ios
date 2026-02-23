//
//  SearchCoordinator.Reducer.swift
//  TapTap
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

struct SearchCoordinator: Reducer {
  typealias State = AppCoordinator.State
  typealias Action = AppCoordinator.Action
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .path(.element(id: _, action: .search(.delegate(.route(let route))))):
        switch route {
        case .back:
          state.path.removeLast()
          return .none
          
        case .linkDetail(let item):
          state.path.append(.linkDetail(.init(article: item)))
          return .none
        }
      default:
        return .none
      }
    }
  }
}
