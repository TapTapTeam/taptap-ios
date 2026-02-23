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
      case route(Route)
    }
    
    public enum Route: Equatable {
      case back
      case extensionSetting
      case shareSetting
      case favoriteSetting
      case policyDetail(title: String, text: String)
      case openSourceList
      case onboardingHighlightGuide
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .serviceOpenLinkTapped:
        return .none
        
      case .delegate:
        return .none
        
      default:
        return .none
      }
    }
    
    SettingNavigationReducer()
  }
  
  public init() {}
}
