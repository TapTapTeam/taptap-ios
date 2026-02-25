//
//  AppCoordinator.Path.swift
//  TapTap
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

import AddLinkFeature
import LinkDetailFeature
import LinkListFeature
import MyCategoryFeature
import OnboardingFeature
import OriginalFeature
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
    case linkList(LinkListFeature)
    case deleteLink(DeleteLinkFeature)
    case movieLink(MoveLinkFeature)
    
    // MyCategory
    case addCategory(AddCategoryFeature)
    case deleteCategory(DeleteCategoryFeature)
    case editCategory(EditCategoryFeature)
    case editCategoryIconName(EditCategoryIconNameFeature)
    case myCategoryCollection(MyCategoryCollectionFeature)
    
    // Onboarding
    case onboardingHighlightGuide(OnboardingHighlightGuideFeature)
    
    // Original
    case originalArticle(OriginalArticleFeature)
    case originalEdit(OriginalEditFeature)
    
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
