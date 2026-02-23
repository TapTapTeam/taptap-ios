//
//  SettingNavigation.Reducer.swift
//  SettingFeature
//
//  Created by 여성일 on 2/21/26.
//

import ComposableArchitecture

import Shared
 
struct SettingNavigationReducer: Reducer {
  typealias State = SettingFeature.State
  typealias Action = SettingFeature.Action
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .safariExtensionTipTapped:
        return .send(.delegate(.route(.extensionSetting)))
        
      case .highlightTipTapped:
        return .send(.delegate(.route(.onboardingHighlightGuide)))
        
      case .shareTipTapped:
        return .send(.delegate(.route(.shareSetting)))
        
      case .favoriteTipTapped:
        return .send(.delegate(.route(.favoriteSetting)))
        
      case .privacyPolicyTapped:
        return .send(.delegate(.route(.policyDetail(
          title: "개인정보 처리방침",
          text: Constants.AppInfo.privacyPolicy
        ))))
        
      case .termsOfServiceTapped:
        return .send(.delegate(.route(.policyDetail(
          title: "서비스 이용약관",
          text: Constants.AppInfo.privacyPolicy
        ))))
        
      case .openSourceTapped:
        return .send(.delegate(.route(.openSourceList)))
        
      default:
        return .none
      }
    }
  }
}
