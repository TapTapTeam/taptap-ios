//
//  Project.swift
//  Manifests
//
//  Created by Hong on 12/30/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let macSafariExtensionTarget = Target.target(
  name: "MacSafariExtension",
  destinations: .macOS,
  product: .appExtension,
  deploymentTargets: .macOS("15.0"),
  infoPlist: .file(path: "MacSafariExtension/Info.plist"),
  sources: [
    "../App/SafariExtension/Sources/**",
    "../Core/Sources/**"
  ],
  resources: [
    "../App/SafariExtension/Resources/manifest.json",
    "../App/SafariExtension/Resources/popup.html",
    "../App/SafariExtension/Resources/*.js",
    "../App/SafariExtension/Resources/*.css",
    "../App/SafariExtension/Resources/images/**",
    "../App/SafariExtension/Resources/_locales/**"
  ],
  entitlements: .file(path: "MacSafariExtension.entitlements")
)

let project = Project.project(
  name: Module.TapTapMac.rawValue,
  targets: [
    Target.target(
      name: Module.TapTapMac.rawValue,
      destinations: .macOS,
      product: .app,
      deploymentTargets: .macOS("15.0"),
      // macOS 앱스토어 업로드에는 LSApplicationCategoryType이 필수다. (altool 90242)
      // 버전 키가 없으면 Tuist 기본값(1.0/1)으로 고정되어 익스텐션 버전과 어긋난다.
      infoPlist: .extendingDefault(with: [
        "LSApplicationCategoryType": "public.app-category.productivity",
        "CFBundleShortVersionString": "$(MARKETING_VERSION)",
        "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
        "ITSAppUsesNonExemptEncryption": false
      ]),
      sources: .sources,
      resources: .default,
      entitlements: .file(path: "TapTapMac.entitlements"),
      dependencies: [
        .target(name: "MacSafariExtension"),
        .core(),
        .designSystem(),
        .macSearchFeature(),
        .macAddLinkFeature(),
        .macLinkListFeature(),
        .macLinkDetailFeature()
      ]
    ),
    macSafariExtensionTarget
  ]
)
