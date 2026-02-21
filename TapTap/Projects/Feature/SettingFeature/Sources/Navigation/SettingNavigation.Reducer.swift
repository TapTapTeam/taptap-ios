//
//  SettingNavigation.Reducer.swift
//  SettingFeature
//
//  Created by 여성일 on 2/21/26.
//

import ComposableArchitecture

struct SettingNavigationReducer: Reducer {
  typealias State = SettingFeature.State
  typealias Action = SettingFeature.Action

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {

      case .path(.element(id: _, action: .extensionSetting(.route(.back)))),
          .path(.element(id: _, action: .shareSetting(.route(.back)))),
          .path(.element(id: _, action: .favoriteSetting(.route(.back)))),
          .path(.element(id: _, action: .policyDetail(.route(.back)))),
          .path(.element(id: _, action: .openSourceList(.route(.back)))):
        state.path.removeLast()
        return .none
        
      default:
        return .none
      }
    }
  }
}
