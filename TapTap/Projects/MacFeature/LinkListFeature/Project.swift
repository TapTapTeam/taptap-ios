//
//  Project.swift
//  LinkList
//
//  Created by TapTap on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: MacFeatureModule.MacLinkListFeature.rawValue,
  targets: [
    Target.target(
      name: MacFeatureModule.MacLinkListFeature.rawValue,
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
      name: "\(MacFeatureModule.MacLinkListFeature.rawValue)Example",
      destinations: [.mac],
      product: .app,
      sources: ["Example/**"],
      dependencies: [
        .target(name: MacFeatureModule.MacLinkListFeature.rawValue),
        .core()
      ]
    ),
    Target.target(
      name: "\(MacFeatureModule.MacLinkListFeature.rawValue)Tests",
      destinations: [.mac],
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: MacFeatureModule.MacLinkListFeature.rawValue),
        .core()
      ]
    )
  ]
)
