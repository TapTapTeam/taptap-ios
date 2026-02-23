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
      // MARK: - 부모(최상위) 피쳐 네비게이션
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
        
        default:
          return .none
        }
        
      // MARK: - 자식(하위) 피쳐 네비게이션
      case .path(.element(id: _, action: .extensionSetting(.delegate(.route(.back))))):
        if !state.path.isEmpty { state.path.removeLast() }
        return .none
        
      case .path(.element(id: _, action: .shareSetting(.delegate(.route(.back))))):
        if !state.path.isEmpty { state.path.removeLast() }
        return .none
        
      case .path(.element(id: _, action: .favoriteSetting(.delegate(.route(.back))))):
        if !state.path.isEmpty { state.path.removeLast() }
        return .none
        
      case .path(.element(id: _, action: .policyDetail(.delegate(.route(.back))))):
        if !state.path.isEmpty { state.path.removeLast() }
        return .none
         
      case .path(.element(id: _, action: .openSourceList(.delegate(.route(.back))))):
        if !state.path.isEmpty { state.path.removeLast() }
        return .none
        
      default:
        return .none
      }
    }
  }
}
