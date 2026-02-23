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
  
  // SettingFeature
  case setting
  case extensionSetting
  case shareSetting
  case favoriteSetting
  case policyDetail(title: String, text: String)
  case openSourceList
  case onboardingHighlightGuide
  
  // OriginalFeature
  case originalArticle(ArticleItem)
  case originalEdit(ArticleItem)
  
  case addLink(CopiedLink?)
  case addCategory
  case linkDetail(ArticleItem)
  case linkList
  case search
  

}
