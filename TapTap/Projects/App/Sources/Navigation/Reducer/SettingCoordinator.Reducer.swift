//
//  SettingCoordinatorReducer.swift
//  TapTap
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

struct SettingCoordinatorReducer: Reducer {
  typealias State = AppCoordinator.State
  typealias Action = AppCoordinator.Action
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {

      case .path(.element(id: _, action: .setting(.delegate(.route(let route))))):
        switch route {
        case .back:
          state.path.removeLast()
          return .none
          
        case .extensionSetting:
          state.path.append(.extensionSetting(.init()))
          return .none
        
        case .onboardingHighlightGuide:
          state.path.append(.onboardingHighlightGuide(.init()))
          return .none
          
        case .shareSetting:
          state.path.append(.shareSetting(.init()))
          return .none
          
        case .favoriteSetting:
          state.path.append(.favoriteSetting(.init()))
          return .none
          
        case let .policyDetail(title, text):
          state.path.append(.policyDetail(.init(title: title, text: text)))
          return .none
          
        case .openSourceList:
          state.path.append(.openSourceList(.init()))
          return .none
        }
        
      case .path(.element(id: _, action: .extensionSetting(.route(.back)))),
           .path(.element(id: _, action: .shareSetting(.route(.back)))),
           .path(.element(id: _, action: .favoriteSetting(.route(.back)))),
           .path(.element(id: _, action: .policyDetail(.route(.back)))),
           .path(.element(id: _, action: .openSourceList(.route(.back)))),
           .path(.element(id: _, action: .onboardingHighlightGuide(.route(.back)))):
        state.path.removeLast()
        return .none
        
      default:
        return .none
      }
    }
  }
}
