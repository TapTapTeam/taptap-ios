//
//  MyCategoryCoordinator.Reducer.swift
//  TapTap
//
//  Created by 여성일 on 2/24/26.
//

import ComposableArchitecture

struct MyCategoryCoordinator: Reducer {
  typealias State = AppCoordinator.State
  typealias Action = AppCoordinator.Action
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      // MARK: - 부모(최상위) 피쳐 네비게이션
      case .path(.element(id: _, action: .myCategoryCollection(.delegate(.route(let route))))):
        switch route {
        case .back:
          state.path.removeLast()
          return .none
        
        case .addCategory:
          state.path.append(.addCategory(.init()))
          return .none
        
        case .deleteCategory:
          state.path.append(.deleteCategory(.init()))
          return .none
          
        case .editCategory:
          state.path.append(.editCategory(.init()))
          return .none
          
        case .linkList(let categoryName):
          state.path.append(.linkList(.init(initialCategoryName: categoryName)))
          return .none

        default:
          return .none
        }
      // MARK: - 자식(하위) 피쳐 네비게이션
      case .path(.element(id: _, action: .addCategory(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none
      
      case .path(.element(id: _, action: .editCategory(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none
        
      case .path(.element(id: _, action: .editCategory(.delegate(.route(.editCategoryIconName(let category)))))):
        state.path.append(.editCategoryIconName(.init(category: category)))
        return .none
        
      case .path(.element(id: _, action: .editCategoryIconName(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none
        
      case .path(.element(id: _, action: .deleteCategory(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none

      default:
        return .none
      }
    }
  }
}
