//
//  SettingFeature.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import Foundation

import ComposableArchitecture

import Domain
import Shared
import OnboardingFeature

@Reducer
struct SettingFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    var path: StackState<Path.State> = .init()
  }
  
  enum Action: Equatable {
    case path(StackActionOf<Path>)
    
    case backButtonTapped
    case privacyPolicyTapped
    case termsOfServiceTapped
    case openSourceTapped
    case safariTipTapped
    case highlightTipTapped
    case shareTipTapped
    case favoriteTipTapped
    case openLinkTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { _ in
          await linkNavigator.pop()
        }
        
      case .privacyPolicyTapped:
        linkNavigator.push(
          .policyDetail,
          PolicyDetailPayload(
            title: "개인정보 처리방침",
            text: Constants.AppInfo.privacyPolicy
          )
        )
        return .none
        
      case .termsOfServiceTapped:
        linkNavigator.push(
          .policyDetail,
          PolicyDetailPayload(
            title: "서비스 이용약관",
            text: Constants.AppInfo.termsOfService
          )
        )
        return .none
        
      case .openSourceTapped:
        linkNavigator.push(.openSourceList, nil)
        return .none
        
      case .safariTipTapped:
        linkNavigator.push(.extensionSetting, nil)
        return .none
        
      case .highlightTipTapped:
        state.path.append(.onboardingHighlightGuide(.init()))
        return .none
      
      case .path(.element(id: _, action: .onboardingHighlightGuide(.backButtonTapped))):
        state.path.removeLast()
        return .none
        
      case .shareTipTapped:
        linkNavigator.push(.shareSetting, nil)
        return .none
        
      case .favoriteTipTapped:
        linkNavigator.push(.favoriteSetting, nil)
        return .none
        
      case .openLinkTapped:
        return .none
        
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
  
  @Reducer(state: .equatable, action: .equatable)
  enum Path {
    case onboardingHighlightGuide(OnboardingHighlightGuideFeature)
  }
}
