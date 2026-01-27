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
        .searchClient()
      ]
    ),
    Target.target(
      name: "\(FeatureModule.SearchFeature.rawValue)Example",
      product: .app,
      infoPlist: .default,
      sources: ["Example/**"],
      resources: .default,
      dependencies: [
        .target(name: FeatureModule.SearchFeature.rawValue)
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
