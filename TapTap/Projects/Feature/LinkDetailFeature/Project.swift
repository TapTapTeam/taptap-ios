//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.LinkDetailFeature.rawValue,
  targets: [
    Target.target(
      name: Module.LinkDetailFeature.rawValue,
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
      name: "\(Module.LinkDetailFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: Module.LinkDetailFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
