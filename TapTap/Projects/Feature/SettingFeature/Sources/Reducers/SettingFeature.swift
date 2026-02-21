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
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  public struct State: Equatable {
    var path: StackState<Path.State> = .init()
  }
  
  public enum Action: Equatable {
    case path(StackActionOf<Path>)
    
    case backButtonTapped
    case safariExtensionTipTapped
    case highlightTipTapped
    case shareTipTapped
    case favoriteTipTapped
    case privacyPolicyTapped
    case termsOfServiceTapped
    case openSourceTapped
    case serviceOpenLinkTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .none
        
      case .safariExtensionTipTapped:
        state.path.append(.extensionSetting(.init()))
        return .none
        
      case .highlightTipTapped:
        return .none
        
      case .shareTipTapped:
        state.path.append(.shareSetting(.init()))
        return .none
        
      case .favoriteTipTapped:
        state.path.append(.favoriteSetting(.init()))
        return .none
        
      case .privacyPolicyTapped:
        state.path.append(.policyDetail(.init(title: "개인정보 처리방침", text: Constants.AppInfo.privacyPolicy)))
        return .none
        
      case .termsOfServiceTapped:
        state.path.append(.policyDetail(.init(title: "서비스 이용약관", text: Constants.AppInfo.privacyPolicy)))
        return .none
        
      case .openSourceTapped:
        state.path.append(.openSourceList(.init()))
        return .none
        
      case .serviceOpenLinkTapped:
        return .none
        
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    
    SettingNavigationReducer()
  }
}
