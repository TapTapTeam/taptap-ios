import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: FeatureModule.AddLinkFeature.rawValue,
  targets: [
    Target.target(
      name: FeatureModule.AddLinkFeature.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .TCA(),
        .domain(),
        .LinkNavigator(),
        .Lottie()
      ]
    ),
    Target.target(
      name: "\(FeatureModule.AddLinkFeature.rawValue)Example",
      product: .app,
      infoPlist: .default,
      sources: ["Example/**"],
      resources: .default,
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
