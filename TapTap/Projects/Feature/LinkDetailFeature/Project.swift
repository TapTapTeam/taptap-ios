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
        .core(),
        .LinkNavigator(),
        .Lottie(),
        .shared()
      ]
    ),
    Target.target(
      name: "\(FeatureModule.LinkDetailFeature.rawValue)Example",
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
