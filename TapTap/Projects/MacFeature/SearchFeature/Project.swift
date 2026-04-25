//
//  Project.swift
//  Manifests
//
//  Created by 여성일 on 4/1/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: MacFeatureModule.MacSearchFeature.rawValue,
  targets: [
    Target.target(
      name: MacFeatureModule.MacSearchFeature.rawValue,
      destinations: [.mac],
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .core(),
        .designSystem()
      ]
    ),
    Target.target(
      name: "\(MacFeatureModule.MacSearchFeature.rawValue)Example",
      destinations: [.mac],
      product: .app,
      sources: ["Example/**"],
      dependencies: [
        .target(name: MacFeatureModule.MacSearchFeature.rawValue),
        .core()
      ]
    ),
    Target.target(
      name: "\(MacFeatureModule.MacSearchFeature.rawValue)Tests",
      destinations: [.mac],
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: MacFeatureModule.MacSearchFeature.rawValue),
        .core()
      ]
    )
  ]
)
