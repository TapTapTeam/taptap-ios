//
//  MyCategoryNavigation.Reducer.swift
//  MyCategoryFeature
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

struct MyCateogryNavigationReducer: Reducer {
  typealias State = MyCategoryCollectionFeature.State
  typealias Action = MyCategoryCollectionFeature.Action

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .path(.element(id: _, action: .editCategory(.route(.editCategoryIconName(category))))):
        state.path.append(.editCategoryIconName(.init(category: category)))
        return .none
        
      case .path(.element(id: _, action: .editCategory(.route(.back)))),
          .path(.element(id: _, action: .editCategoryIconName(.route(.back)))),
          .path(.element(id: _, action: .addCategory(.route(.back)))),
          .path(.element(id: _, action: .deleteCategory(.route(.back)))):
        state.path.removeLast()
        return .none
        
      default:
        return .none
      }
    }
  }
}
