//
//  AppCoordinator.Path.swift
//  TapTap
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

import AddLinkFeature
import LinkDetailFeature
import MyCategoryFeature
import OnboardingFeature
import SearchFeature
import SettingFeature

extension AppCoordinator {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    // AddLink
    case addLink(AddLinkFeature)
    
    // LinkDetail
    case linkDetail(LinkDetailFeature)
    
    // LinkList
    
    // MyCategory
    case addCategory(AddCategoryFeature)
    
    // Onboarding
    case onboardingHighlightGuide(OnboardingHighlightGuideFeature)
    
    // Original
    
    // Search
    case search(SearchFeature)
    
    // Setting
    case setting(SettingFeature)
    case extensionSetting(ExtensionSettingFeature)
    case shareSetting(ShareSettingFeature)
    case favoriteSetting(FavoriteSettingFeature)
    case policyDetail(PolicyDetailFeature)
    case openSourceList(OpenSourceListFeature)
  }
}
