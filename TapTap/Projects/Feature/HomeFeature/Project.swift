import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: FeatureModule.HomeFeature.rawValue,
  targets: [
    Target.target(
      name: FeatureModule.HomeFeature.rawValue,
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .TCA(),
        .domain(),
        .LinkNavigator(),
        .Lottie(),
        .shared(),
        .myCategoryFeature(),
      ]
    ),
    Target.target(
      name: "\(FeatureModule.HomeFeature.rawValue)Example",
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
        .target(name: FeatureModule.HomeFeature.rawValue)
      ]
    ),
    Target.target(
      name: "\(FeatureModule.HomeFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: FeatureModule.HomeFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
