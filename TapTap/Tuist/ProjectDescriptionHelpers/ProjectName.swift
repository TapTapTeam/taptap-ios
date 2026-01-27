//
//  ProjectName.swift
//  Manifests
//
//  Created by Hong on 10/5/25.
//

import ProjectDescription

public enum Module: String {
  case App
  case Feature
  case DesignSystem
  case Domain
  case TapTapMac
}

public enum FeatureModule: String {
  case SettingFeature
  case SearchFeature
  case OriginalFeature
  case OnboardingFeature
  case MyCategoryFeature
  case LinkListFeature
  case LinkDetailFeature
  case AddLinkFeature
  case HomeFeature
}

public enum ClientModule: String {
  case AddLinkClient
  case SearchClient
  case LinkDetailClient
  case LinkListClient
  case MyCategoryClient
  case OriginalClient
  case HomeClient
}

extension Module: CaseIterable {}
extension FeatureModule: CaseIterable {}
extension ClientModule: CaseIterable {}
