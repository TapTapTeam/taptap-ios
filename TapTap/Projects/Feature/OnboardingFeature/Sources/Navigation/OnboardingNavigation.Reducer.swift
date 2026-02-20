//
//  OnboardingNavigationReducer.swift
//  OnboardingFeature
//
//  Created by 여성일 on 2/21/26.
//

import ComposableArchitecture

struct OnboardingNavigationReducer: Reducer {
  typealias State = OnboardingFeature.State
  typealias Action = OnboardingFeature.Action

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {

      case .path(.element(id: _, action: .onboardingSafariSetting(.route(.onboardingHighlightMemo)))):
        state.path.append(.onboardingHighlightMemo(.init()))
        return .none

      case .path(.element(id: _, action: .onboardingHighlightMemo(.route(.onboardingHighlightGuide)))):
        state.path.append(.onboardingHighlightGuide(.init()))
        return .none

      case .path(.element(id: _, action: .onboardingHighlightMemo(.route(.onboardingShare)))):
        state.path.append(.onboardingShare(.init()))
        return .none

      case .path(.element(id: _, action: .onboardingHighlightGuide(.route(.onboardingShare)))):
        state.path.append(.onboardingShare(.init()))
        return .none

      case .path(.element(id: _, action: .onboardingShare(.route(.onboardingShareGuide)))):
        state.path.append(.onboardingShareGuide(.init()))
        return .none

      case .path(.element(id: _, action: .onboardingShare(.route(.onboardingFinish)))):
        state.path.append(.onboardingFinish(.init()))
        return .none

      case .path(.element(id: _, action: .onboardingShareGuide(.route(.onboardingFinish)))):
        state.path.append(.onboardingFinish(.init()))
        return .none

      case .path(.element(id: _, action: .onboardingFinish(.route(.home)))):
        return .send(.delegate(.onboardingCompleted))

      case .path(.element(id: _, action: .onboardingHighlightMemo(.route(.back)))),
          .path(.element(id: _, action: .onboardingHighlightGuide(.route(.back)))),
          .path(.element(id: _, action: .onboardingShare(.route(.back)))),
          .path(.element(id: _, action: .onboardingShareGuide(.route(.back)))):
        state.path.removeLast()
        return .none
        
      default:
        return .none
      }
    }
  }
}
