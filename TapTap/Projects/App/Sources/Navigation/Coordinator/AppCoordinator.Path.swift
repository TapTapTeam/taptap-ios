//
//  AppCoordinator.Path.swift
//  TapTap
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

import MyCategoryFeature
import AddLinkFeature
import OnboardingFeature
import SettingFeature
import LinkDetailFeature

extension AppCoordinator {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    // AddLink
    case addLink(AddLinkFeature)
    
    // Setting
    case setting(SettingFeature)
    case extensionSetting(ExtensionSettingFeature)
    case shareSetting(ShareSettingFeature)
    case favoriteSetting(FavoriteSettingFeature)
    case policyDetail(PolicyDetailFeature)
    case openSourceList(OpenSourceListFeature)
    
    // Onboarding
    case onboardingHighlightGuide(OnboardingHighlightGuideFeature)
    
    // MyCategory
    case addCategory(AddCategoryFeature)
    
    // LinkDetail
    case linkDetail(LinkDetailFeature)
  }
}
