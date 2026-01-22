//
//  Target+Templates.swift
//  Manifests
//
//  Created by Hong on 10/6/25.
//

import ProjectDescription

extension Target {
  public static func target (
    name: String,
    destinations: Destinations? = nil,
    product: Product,
    bundleId: String? = nil,
    deploymentTargets: DeploymentTargets? = nil,
    infoPlist: InfoPlist? = .default,
    sources: SourceFilesList? = nil,
    resources: ResourceFileElements? = nil,
    entitlements: Entitlements? = nil,
    scripts: [TargetScript] = [],
    dependencies: [TargetDependency] = [],
    settings: Settings? = nil,
    xcconfig: Path? = .relativeToRoot("Tuist/Config/Project.xcconfig")
  ) -> Target {
    
    let signing = Target.signingSettings(for: product, name: name)
    
    let finalConfigs: [Configuration]
    if let xcconfig {
      finalConfigs = signing.configs.map {
        switch $0.variant {
        case .debug:
          return .debug(name: $0.name, settings: $0.settings, xcconfig: xcconfig)
        case .release:
          return .release(name: $0.name, settings: $0.settings, xcconfig: xcconfig)
        @unknown default:
          return .debug(name: $0.name, settings: $0.settings, xcconfig: xcconfig)
        }
      }
    } else {
      finalConfigs = signing.configs
    }
    
    return Target.target(
      name: name,
      destinations: destinations ?? .init([.iPhone]),
      product: product,
      bundleId: bundleId ?? Project.bundleIDBase + "." + name,
      deploymentTargets: deploymentTargets ?? .iOS(Project.iosVersion),
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies,
      settings: .settings(
        base: signing.base,
        configurations: finalConfigs
      )
    )
  }
}

extension SourceFilesList {
  public static let sources: SourceFilesList = ["Sources/**"]
  public static let tests: SourceFilesList = ["Tests/**"]
}

extension Target {
  private static func signingSettings(for product: Product, name: String)
  -> (base: [String: SettingValue], configs: [Configuration]) {
    
    let baseSettings: [String: SettingValue] = [
      "CODE_SIGN_STYLE": "Manual",
      "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)"
    ]
    
    var debugSettings: [String: SettingValue] = [
      "CODE_SIGN_IDENTITY": "$(CODE_SIGN_IDENTITY)",
    ]
    var releaseSettings: [String: SettingValue] = [
      "CODE_SIGN_IDENTITY": "$(CODE_SIGN_IDENTITY)",
      "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
      "INFOPLIST_KEY_CFBundleDisplayName": "\(name)",
    ]
    
    switch product {
    case .app:
      debugSettings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIconDev"
      releaseSettings["INFOPLIST_KEY_CFBundleDisplayName"] = "탭탭"
      if name == "TapTapMac" {
        debugSettings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIconDev"
        releaseSettings["INFOPLIST_KEY_CFBundleDisplayName"] = "\(name)Dev"
        debugSettings["PRODUCT_BUNDLE_IDENTIFIER"] = "\(Project.macOSbundleID)"
        releaseSettings["PRODUCT_BUNDLE_IDENTIFIER"] = "\(Project.macOSbundleIDAppStore)"
        debugSettings["PROVISIONING_PROFILE_SPECIFIER"] = "$(PROV_PROFILE_MAC_DEV)"
        releaseSettings["PROVISIONING_PROFILE_SPECIFIER"] = "$(PROV_PROFILE_MAC_RELEASE)"
      } else {
        debugSettings["PRODUCT_BUNDLE_IDENTIFIER"] = "\(Project.bundleIDBase)"
        releaseSettings["PRODUCT_BUNDLE_IDENTIFIER"] = "\(Project.bundIDAppStore)"
        debugSettings["PROVISIONING_PROFILE_SPECIFIER"] = "$(PROV_PROFILE_APP_DEV)"
        releaseSettings["PROVISIONING_PROFILE_SPECIFIER"] = "$(PROV_PROFILE_APP_RELEASE)"
      }
      
    case .appExtension:
      debugSettings["PRODUCT_BUNDLE_IDENTIFIER"] = "\(Project.bundleIDBase).\(name)"
      releaseSettings["PRODUCT_BUNDLE_IDENTIFIER"] = "\(Project.bundIDAppStore).\(name == "shareExtension" ? "actionExtension" : "safariExtension")"
      debugSettings["PROVISIONING_PROFILE_SPECIFIER"] = "$(PROV_PROFILE_\(name.uppercased())_DEV)"
      releaseSettings["PROVISIONING_PROFILE_SPECIFIER"] = "$(PROV_PROFILE_\(name.uppercased())_RELEASE)"
      
    default:
      break
    }
    
    return (
      base: baseSettings,
      configs: [
        .debug(name: "Debug", settings: debugSettings),
        .release(name: "Release", settings: releaseSettings)
      ]
    )
  }
}

