//
//  LinkListNavigation.Reducer.swift
//  LinkListFeature
//
//  Created by 여성일 on 2/22/26.
//

import ComposableArchitecture

struct LinkListNavigationReducer: Reducer {
  typealias State = LinkListFeature.State
  typealias Action = LinkListFeature.Action

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .path(.element(id: _, action: .moveLink(.route(.back)))),
          .path(.element(id: _, action: .deleteLink(.route(.back)))):
        state.path.removeLast()
        return .none
        
      default:
        return .none
      }
    }
  }
}
