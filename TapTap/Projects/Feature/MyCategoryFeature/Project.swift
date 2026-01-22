//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.MyCategoryFeature.rawValue,
  targets: [
    Target.target(
      name: Module.MyCategoryFeature.rawValue,
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
      name: "\(Module.MyCategoryFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: Module.MyCategoryFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
