//
//  LinkListCoordinator.swift
//  TapTap
//
//  Created by 여성일 on 2/24/26.
//

import ComposableArchitecture

struct LinkListCoordinator: Reducer {
  typealias State = AppCoordinator.State
  typealias Action = AppCoordinator.Action
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      // MARK: - 부모(최상위) 피쳐 네비게이션
      case .path(.element(id: _, action: .linkList(.delegate(.route(let route))))):
        switch route {
        case .back:
          state.path.removeLast()
          return .none
          
        case .search:
          state.path.append(.search(.init()))
          return .none
          
        case let .linkDetail(articleItem):
          state.path.append(.linkDetail(.init(article: articleItem)))
          return .none
          
        case let .moveLink(allLinks, categoryName, totalCount):
          state.path.append(.movieLink(.init(allLinks: allLinks, categoryName: categoryName, totalCount: totalCount)))
          return .none
          
        case let .deleteLink(allLinks, categoryName, totalCount):
            state.path.append(.deleteLink(.init(allLinks: allLinks, categoryName: categoryName, totalCount: totalCount)))
            return .none
          
        default:
          return .none
        }
      // MARK: - 자식(하위) 피쳐 네비게이션
      case .path(.element(id: _, action: .deleteLink(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none
      
      case .path(.element(id: _, action: .movieLink(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none
        
      default:
        return .none
      }
    }
  }
}
