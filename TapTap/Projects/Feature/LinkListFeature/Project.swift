//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: FeatureModule.LinkListFeature.rawValue,
  targets: [
    Target.target(
      name: FeatureModule.LinkListFeature.rawValue,
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
      name: "\(FeatureModule.LinkListFeature.rawValue)Example",
      product: .app,
      infoPlist: .default,
      sources: ["Example/**"],
      resources: .default,
      dependencies: [
        .target(name: FeatureModule.LinkListFeature.rawValue)
      ]
    ),
    Target.target(
      name: "\(FeatureModule.LinkListFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: FeatureModule.LinkListFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
