//
//  Project.swift
//  Home
//
//  Created by TapTap on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: MacFeatureModule.MacHomeFeature.rawValue,
  targets: [
    Target.target(
      name: MacFeatureModule.MacHomeFeature.rawValue,
      destinations: [.mac],
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .core()
      ]
    ),
    Target.target(
      name: "\(MacFeatureModule.MacHomeFeature.rawValue)Example",
      destinations: [.mac],
      product: .app,
      sources: ["Example/**"],
      dependencies: [
        .target(name: MacFeatureModule.MacHomeFeature.rawValue),
        .core()
      ]
    ),
    Target.target(
      name: "\(MacFeatureModule.MacHomeFeature.rawValue)Tests",
      destinations: [.mac],
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: MacFeatureModule.MacHomeFeature.rawValue),
        .core()
      ]
    )
  ]
)
