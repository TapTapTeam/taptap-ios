//
//  SettingNavigation.Path.swift
//  SettingFeature
//
//  Created by 여성일 on 2/21/26.
//

import ComposableArchitecture

extension SettingFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case extensionSetting(ExtensionSettingFeature)
    case shareSetting(ShareSettingFeature)
    case favoriteSetting(FavoriteSettingFeature)
    case policyDetail(PolicyDetailFeature)
    case termsOfService(PolicyDetailFeature)
    case openSourceList(OpenSourceListFeature)
  }
}
