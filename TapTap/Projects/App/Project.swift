import ProjectDescription
import ProjectDescriptionHelpers

enum Scheme: String {
  case DEV
  case RELEASE
}

let appTarget = Target.target(
  name: Project.appName,
  product: .app,
  infoPlist: .extendingDefault(
    with: [
      "UILaunchScreen": [
        "UIColorName": "",
        "UIImageName": "",
      ],
      "CFBundleDevelopmentRegion": "ko",
      "CFBundleLocalizations": ["ko"],
      "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
      "CFBundleDisplayName": "$(INFOPLIST_KEY_CFBundleDisplayName)",
      "CFBundleShortVersionString": "$(MARKETING_VERSION)",
      "ITSAppUsesNonExemptEncryption": false,

      // 분석 키는 저장소에 넣지 않는다 — gitignore된 Tuist/Config/Project.xcconfig에서 주입한다.
      // 값이 비면 AnalyticsKit이 Amplitude를 건너뛰고 앱은 그대로 돈다.
      "AMPLITUDE_API_KEY": "$(AMPLITUDE_API_KEY)",

      // Firebase의 화면 자동수집은 UIViewController 기준이라 SwiftUI 앱에선 전부
      // UIHostingController로 뭉개진다 — 끄고 AnalyticsKit이 직접 screen_view를 심는다.
      "FirebaseAutomaticScreenReportingEnabled": false,

      "NSAppTransportSecurity": [
        "NSAllowsArbitraryLoads": true
      ],
      "UIBackgroundModes": [
        "audio",
        "remote-notification"
      ],
      "UISupportedInterfaceOrientations": [
        "UIInterfaceOrientationPortrait"
      ],
      "CFBundleURLTypes": [
        [
          "CFBundleURLSchemes": ["nbs"]
        ]
      ]
    ]
  ),
  sources: .sources,
  resources: .default,
  entitlements: .file(path: "App.entitlements"),
  dependencies: [
    .safariEx(),
    .actionEx(),
    .addLinkFeature(),
    .homeFeature(),
    .linkDetailFeature(),
    .linkListFeature(),
    .myCategoryFeature(),
    .onboardingFeature(),
    .originalFeature(),
    .searchFeature(),
    .settingFeature(),
    .analyticsKit()
  ]
)

let safariTarget = Target.target(
  name: TargetName.safariExtension.rawValue,
  product: .appExtension,
  infoPlist: .file(path: "SafariExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.safariExtension.sourcesPath)],
  resources: [
    "SafariExtension/Resources/manifest.json",
    "SafariExtension/Resources/popup.html",
    "SafariExtension/Resources/*.js",
    "SafariExtension/Resources/*.css",
    "SafariExtension/Resources/images/**",
    "SafariExtension/Resources/_locales/**"
  ],
  entitlements: .file(path: "SafariExtension.entitlements"),
  dependencies: [
    .core()
  ]
)

let shareExtensionTarget = Target.target(
  name: TargetName.shareExtension.rawValue,
  product: .appExtension,
  infoPlist: .file(path: "ShareExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.shareExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.shareExtension.resourcesPath)],
  entitlements: .file(path: "ShareExtension.entitlements"),
  dependencies: [
    .sdk(name: "UniformTypeIdentifiers", type: .framework),
    .designSystem(),
    .core()
  ]
)

let project = Project.project(
  name: Project.appName,
  targets: [
    appTarget,
    safariTarget,
    shareExtensionTarget
  ]
)
