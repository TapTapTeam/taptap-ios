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
      // MARK: - 부모(최상위) 피쳐 네비게이션
      case .path(.element(id: _, action: .search(.delegate(.route(let route))))):
        switch route {
        case .back:
          state.path.removeLast()
          return .none
          
        case .linkDetail(let item):
          state.path.append(.linkDetail(.init(article: item)))
          return .none
          
        default:
          return .none
        }
      // MARK: - 자식(하위) 피쳐 네비게이션
      default:
        return .none
      }
    }
  }
}
