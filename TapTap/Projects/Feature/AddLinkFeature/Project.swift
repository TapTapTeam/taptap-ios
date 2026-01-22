import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.AddLinkFeature.rawValue,
  targets: [
    Target.target(
      name: Module.AddLinkFeature.rawValue,
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
      name: "\(Module.AddLinkFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: Module.AddLinkFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
