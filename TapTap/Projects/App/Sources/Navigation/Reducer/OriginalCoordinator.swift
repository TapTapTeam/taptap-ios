//
//  OriginalCoordinator.swift
//  TapTap
//
//  Created by 여성일 on 2/24/26.
//

import ComposableArchitecture

struct OriginalCoordinator: Reducer {
  typealias State = AppCoordinator.State
  typealias Action = AppCoordinator.Action
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      // MARK: - 부모(최상위) 피쳐 네비게이션
      case .path(.element(id: _, action: .originalArticle(.delegate(.route(let route))))):
        switch route {
        case .back:
          state.path.removeLast()
          return .none
          
        case .originalEdit(let article):
          state.path.append(.originalEdit(.init(articleItem: article)))
          return .none
        
        default:
          return .none
        }
      // MARK: - 자식(하위) 피쳐 네비게이션
      case .path(.element(id: _, action: .originalEdit(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none
        
      default:
        return .none
      }
    }
  }
}
