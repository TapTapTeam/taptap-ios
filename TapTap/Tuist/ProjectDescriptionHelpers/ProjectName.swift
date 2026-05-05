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
  case Core
  case Shared
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

public enum MacFeatureModule: String {
  case MacSearchFeature
  case MacAddLinkFeature
  case MacHomeFeature
  case MacLinkListFeature
}

extension Module: CaseIterable {}
extension FeatureModule: CaseIterable {}
