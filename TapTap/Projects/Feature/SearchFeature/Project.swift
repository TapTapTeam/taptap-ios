//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: FeatureModule.SearchFeature.rawValue,
  targets: [
    Target.target(
      name: FeatureModule.SearchFeature.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .TCA(),
        .domain(),
        .LinkNavigator(),
      ]
    ),
    Target.target(
      name: "\(FeatureModule.SearchFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: FeatureModule.SearchFeature.rawValue),
        .TCA()
      ]
    )

  ]
)
