//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: FeatureModule.OriginalFeature.rawValue,
  targets: [
    Target.target(
      name: FeatureModule.OriginalFeature.rawValue,
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .TCA(),
        .domain(),
        .LinkNavigator(),
        .Lottie(),
        .shared()
      ]
    ),
    Target.target(
      name: "\(FeatureModule.OriginalFeature.rawValue)Example",
      product: .app,
      infoPlist: .extendingDefault(with: [
        "UILaunchScreen": [
          "UIColorName": "",
          "UIImageName": ""
        ],
        "UISupportedInterfaceOrientations": [
          "UIInterfaceOrientationPortrait"
        ]
      ]),
      sources: ["Example/**"],
      dependencies: [
        .target(name: FeatureModule.OriginalFeature.rawValue)
      ]
    ),
    Target.target(
      name: "\(FeatureModule.OriginalFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: FeatureModule.OriginalFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
