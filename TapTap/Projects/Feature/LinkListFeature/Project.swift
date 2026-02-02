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
      name: "\(FeatureModule.LinkListFeature.rawValue)Example",
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
