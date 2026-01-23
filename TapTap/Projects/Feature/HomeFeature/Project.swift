import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: FeatureModule.HomeFeature.rawValue,
  targets: [
    Target.target(
      name: FeatureModule.HomeFeature.rawValue,
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
