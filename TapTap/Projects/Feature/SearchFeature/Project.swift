//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.SearchFeature.rawValue,
  targets: [
    Target.target(
      name: Module.SearchFeature.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .TCA(),
        .domain(),
        .LinkNavigator(),
      ]
    ),
    Target.target(
      name: "\(Module.SearchFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: Module.SearchFeature.rawValue),
        .TCA()
      ]
    )

  ]
)
