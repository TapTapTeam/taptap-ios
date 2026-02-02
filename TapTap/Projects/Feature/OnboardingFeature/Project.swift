//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: FeatureModule.OnboardingFeature.rawValue,
  targets: [
    Target.target(
      name: FeatureModule.OnboardingFeature.rawValue,
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
      name: "\(FeatureModule.OnboardingFeature.rawValue)Example",
      product: .app,
      infoPlist: .default,
      sources: ["Example/**"],
      dependencies: [
        .target(name: FeatureModule.OnboardingFeature.rawValue)
      ]
    ),
    Target.target(
      name: "\(FeatureModule.OnboardingFeature.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: FeatureModule.OnboardingFeature.rawValue),
        .TCA()
      ]
    )
  ]
)
