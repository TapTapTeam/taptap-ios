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
      resources: .default,
      dependencies: [
        .TCA(),
        .domain(),
        .LinkNavigator(),
        .Lottie(),
        .shared(),
        .onboardingFeature()
      ]
    ),
    Target.target(
      name: "\(FeatureModule.MyCategoryFeature.rawValue)Example",
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
