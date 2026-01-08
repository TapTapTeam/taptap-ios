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
      "CFBundleVersion": "$(CFBundleVersion)",
      "CFBundleDisplayName": "$(INFOPLIST_KEY_CFBundleDisplayName)",
      "CFBundleShortVersionString": "$(CFBundleShortVersionString)",

      "NSAppTransportSecurity": [
        "NSAllowsArbitraryLoads": true
      ],
      "UIBackgroundModes": [
        "audio"
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
    .feature(),
  ]
)

let safariTarget = Target.target(
  name: TargetName.safariExtension.rawValue,
  product: .appExtension,
  infoPlist: .file(path: "SafariExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.safariExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.safariExtension.resourcesPath)],
  entitlements: .file(path: "SafariExtension.entitlements"),
  dependencies: [
    .domain()
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
    .domain()
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
