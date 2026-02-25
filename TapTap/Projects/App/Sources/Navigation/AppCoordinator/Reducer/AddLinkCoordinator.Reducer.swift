//
//  AddLinkCoordinator.Reducer.swift
//  TapTap
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

struct AddLinkCoordinatorReducer: Reducer {
  typealias State = AppCoordinator.State
  typealias Action = AppCoordinator.Action
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      // MARK: - 부모(최상위) 피쳐 네비게이션
      case .path(.element(id: _, action: .addLink(.delegate(.route(let route))))):
        switch route {
        case .back:
          state.path.removeLast()
          return .none
          
        case .addCategory:
          state.path.append(.addCategory(.init()))
          return .none
          
        case let .linkDetail(article):
          state.path.append(.linkDetail(.init(article: article)))
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
