//
//  AppRoute.swift
//  Shared
//
//  Created by 여성일 on 2/21/26.
//

import Foundation

import Core

public enum AppRoute: Equatable {
  case back
  
  // AddLinkFeature
  case addLink(CopiedLink?)
  
  // SettingFeature
  case setting
  case extensionSetting
  case shareSetting
  case favoriteSetting
  case policyDetail(title: String, text: String)
  case openSourceList
  
  // OriginalFeature
  case originalArticle(ArticleItem)
  case originalEdit(ArticleItem)
  
  // OnboardingFeature
  case onboardingSafariSetting
  case onboardingHighlightGuide
  case onboardingHighlightMemo
  case onboardingShare
  case onboardingShareGuide
  case onboardingFinish
  
  
  // LinkDetailFeature
  case linkDetail(ArticleItem)
  
  // LinkListFeature
  case linkList(initCategory: String)
  case moveLink(allLinks: [ArticleItem], categoryName: String)
  case deleteLink(allLinks: [ArticleItem], categoryName: String)
  
  // MyCategoryFeature
  case addCategory
  case deleteCategory
  case editCategory
  case editCategoryIconName(CategoryItem)
  case myCategoryCollection

  // SearchFeature
  case search
  

}
