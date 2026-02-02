//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: FeatureModule.LinkDetailFeature.rawValue,
  targets: [
    Target.target(
      name: FeatureModule.LinkDetailFeature.rawValue,
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .TCA(),
        .domain(),
        .LinkNavigator(),
        .Lottie(),
      ]
    ),
    Target.target(
      name: "\(FeatureModule.LinkDetailFeature.rawValue)Example",
      product: .app,
      infoPlist: .default,
      sources: ["Example/**"],
      dependencies: [
        .target(name: FeatureModule.LinkDetailFeature.rawValue)
      ]
    ),
    Target.target(
      name: "\(FeatureModule.LinkDetailFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: FeatureModule.LinkDetailFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
