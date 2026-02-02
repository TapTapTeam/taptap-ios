//
//  TargetDependency+Module.swift
//  Manifests
//
//  Created by Hong on 10/6/25.
//

import ProjectDescription

// MARK: - Feature
extension TargetDependency {
  public static func feature() -> TargetDependency {
    .project(target: Module.Feature.rawValue, path: .relativeToRoot("Projects/Feature"))
  }
}

extension TargetDependency {
  public static func addLinkFeature() -> TargetDependency {
    .project(target: FeatureModule.AddLinkFeature.rawValue, path: .relativeToRoot("Projects/Feature/AddLinkFeature"))
  }
}

extension TargetDependency {
  public static func homeFeature() -> TargetDependency {
    .project(target: FeatureModule.HomeFeature.rawValue, path: .relativeToRoot("Projects/Feature/homeFeature"))
  }
}

extension TargetDependency {
  public static func linkDetailFeature() -> TargetDependency {
    .project(target: FeatureModule.LinkDetailFeature.rawValue, path: .relativeToRoot("Projects/Feature/LinkDetailFeature"))
  }
}

extension TargetDependency {
  public static func linkListFeature() -> TargetDependency {
    .project(target: FeatureModule.LinkListFeature.rawValue, path: .relativeToRoot("Projects/Feature/LinkListFeature"))
  }
}

extension TargetDependency {
  public static func myCategoryFeature() -> TargetDependency {
    .project(target: FeatureModule.MyCategoryFeature.rawValue, path: .relativeToRoot("Projects/Feature/MyCategoryFeature"))
  }
}

extension TargetDependency {
  public static func onboardingFeature() -> TargetDependency {
    .project(target: FeatureModule.OnboardingFeature.rawValue, path: .relativeToRoot("Projects/Feature/OnboardingFeature"))
  }
}

extension TargetDependency {
  public static func originalFeature() -> TargetDependency {
    .project(target: FeatureModule.OriginalFeature.rawValue, path: .relativeToRoot("Projects/Feature/OriginalFeature"))
  }
}

extension TargetDependency {
  public static func searchFeature() -> TargetDependency {
    .project(target: FeatureModule.SearchFeature.rawValue, path: .relativeToRoot("Projects/Feature/SearchFeature"))
  }
}

extension TargetDependency {
  public static func settingFeature() -> TargetDependency {
    .project(target: FeatureModule.SettingFeature.rawValue, path: .relativeToRoot("Projects/Feature/SettingFeature"))
  }
}

// MARK: - Design
extension TargetDependency {
  public static func designSystem() -> TargetDependency {
    .project(target: Module.DesignSystem.rawValue, path: .relativeToRoot("Projects/DesignSystem"))
  }
}

// MARK: - Extension
extension TargetDependency {
  public static func safariEx() -> TargetDependency {
    .target(name: TargetName.safariExtension.rawValue)
  }
}

extension TargetDependency {
  public static func actionEx() -> TargetDependency {
    .target(name: TargetName.shareExtension.rawValue)
  }
}

extension TargetDependency {
  public static func domain() -> TargetDependency {
    .project(target: Module.Domain.rawValue, path: .relativeToRoot("Projects/Domain"))
  }
}
