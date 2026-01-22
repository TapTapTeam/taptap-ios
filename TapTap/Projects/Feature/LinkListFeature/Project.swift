//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.LinkListFeature.rawValue,
  targets: [
    Target.target(
      name: Module.LinkListFeature.rawValue,
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
      name: "\(Module.LinkListFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: Module.LinkListFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
