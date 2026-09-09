//
//  SettingFeature.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import Foundation

import ComposableArchitecture

import AnalyticsKit
import Core
import Shared

@Reducer
public struct SettingFeature {
  @Dependency(\.analytics) var analytics

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case onAppear
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
      case .onAppear:
        analytics.track(UsageEvent.screenViewed(.setting))
        return .none
        
      case .serviceOpenLinkTapped:
        analytics.track(UsageEvent.settingRowTapped(row: "service_open_link"))
        return .none
        
      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .safariExtensionTipTapped:
        analytics.track(UsageEvent.settingRowTapped(row: "safari_extension_tip"))
        return .send(.delegate(.route(.extensionSetting)))
        
      case .highlightTipTapped:
        analytics.track(UsageEvent.settingRowTapped(row: "highlight_tip"))
        return .send(.delegate(.route(.onboardingHighlightGuide)))
        
      case .shareTipTapped:
        analytics.track(UsageEvent.settingRowTapped(row: "share_tip"))
        return .send(.delegate(.route(.shareSetting)))
        
      case .favoriteTipTapped:
        analytics.track(UsageEvent.settingRowTapped(row: "favorite_tip"))
        return .send(.delegate(.route(.favoriteSetting)))
        
      case .privacyPolicyTapped:
        analytics.track(UsageEvent.settingRowTapped(row: "privacy_policy"))
        return .send(.delegate(.route(.policyDetail(
          title: "개인정보 처리방침",
          text: Constants.AppInfo.privacyPolicy
        ))))
        
      case .termsOfServiceTapped:
        analytics.track(UsageEvent.settingRowTapped(row: "terms_of_service"))
        return .send(.delegate(.route(.policyDetail(
          title: "서비스 이용약관",
          text: Constants.AppInfo.privacyPolicy
        ))))
        
      case .openSourceTapped:
        analytics.track(UsageEvent.settingRowTapped(row: "open_source"))
        return .send(.delegate(.route(.openSourceList)))
      
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
