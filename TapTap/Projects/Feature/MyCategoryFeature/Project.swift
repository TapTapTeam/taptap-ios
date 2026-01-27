//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: FeatureModule.MyCategoryFeature.rawValue,
  targets: [
    Target.target(
      name: FeatureModule.MyCategoryFeature.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .TCA(),
        .domain(),
        .LinkNavigator(),
        .Lottie(),
        .myCategoryClient()
      ]
    ),
    Target.target(
      name: "\(FeatureModule.MyCategoryFeature.rawValue)Example",
      product: .app,
      infoPlist: .default,
      sources: ["Example/**"],
      resources: .default,
      dependencies: [
        .target(name: FeatureModule.MyCategoryFeature.rawValue)
      ]
    ),
    Target.target(
      name: "\(FeatureModule.MyCategoryFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: FeatureModule.MyCategoryFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
