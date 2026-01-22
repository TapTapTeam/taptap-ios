import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.HomeFeature.rawValue,
  targets: [
    Target.target(
      name: Module.HomeFeature.rawValue,
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
      name: "\(Module.HomeFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: Module.HomeFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
