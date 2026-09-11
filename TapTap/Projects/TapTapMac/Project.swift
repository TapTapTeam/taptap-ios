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
      // 표시 이름을 매핑하지 않으면 빌드 설정의 INFOPLIST_KEY_CFBundleDisplayName이
      // 조용히 버려지고 CFBundleName($(PRODUCT_NAME) = TapTapMac)이 그대로 노출된다. → 5.2.5 리젝
      infoPlist: .extendingDefault(with: [
        "LSApplicationCategoryType": "public.app-category.productivity",
        "CFBundleDisplayName": "$(INFOPLIST_KEY_CFBundleDisplayName)",
        // CFBundleName도 같이 덮는다. macOS는 메뉴바 앱 메뉴와 정보 패널에 이 값을 쓰므로
        // 여기에 TapTapMac이 남으면 실행 중인 앱에 Apple 제품명이 그대로 보인다.
        "CFBundleName": "$(INFOPLIST_KEY_CFBundleDisplayName)",
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
