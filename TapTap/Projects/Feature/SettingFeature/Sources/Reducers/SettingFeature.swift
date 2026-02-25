//
//  SettingFeature.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import Foundation

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct SettingFeature {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case safariExtensionTipTapped
    case highlightTipTapped
    case shareTipTapped
    case favoriteTipTapped
    case privacyPolicyTapped
    case termsOfServiceTapped
    case openSourceTapped
    case serviceOpenLinkTapped
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .serviceOpenLinkTapped:
        return .none
        
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
      
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
