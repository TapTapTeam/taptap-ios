import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: FeatureModule.AddLinkFeature.rawValue,
  targets: [
    Target.target(
      name: FeatureModule.AddLinkFeature.rawValue,
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .TCA(),
        .domain(),
        .LinkNavigator(),
        .Lottie(),
        .shared(),
        .myCategoryFeature()
      ]
    ),
    Target.target(
      name: "\(FeatureModule.AddLinkFeature.rawValue)Example",
      product: .app,
      infoPlist: .extendingDefault(with: [
        "UILaunchScreen": [
          "UIColorName": "",
          "UIImageName": ""
        ],
        "UISupportedInterfaceOrientations": [
          "UIInterfaceOrientationPortrait"
        ]
      ]),
      sources: ["Example/**"],
      dependencies: [
        .target(name: FeatureModule.AddLinkFeature.rawValue)
      ]
    ),
    Target.target(
      name: "\(FeatureModule.AddLinkFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: FeatureModule.AddLinkFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
