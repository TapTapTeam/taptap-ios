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
      resources: .default,
      dependencies: [
        .TCA(),
        .domain(),
        .LinkNavigator(),
        .shared()
      ]
    ),
    Target.target(
      name: "\(FeatureModule.SearchFeature.rawValue)Example",
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
