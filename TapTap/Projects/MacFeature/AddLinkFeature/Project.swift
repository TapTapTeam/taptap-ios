//
//  Project.swift
//  AddLink
//
//  Created by TapTap on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: MacFeatureModule.MacAddLinkFeature.rawValue,
  targets: [
    Target.target(
      name: MacFeatureModule.MacAddLinkFeature.rawValue,
      destinations: [.mac],
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .core()
      ]
    ),
    Target.target(
      name: "\(MacFeatureModule.MacAddLinkFeature.rawValue)Example",
      destinations: [.mac],
      product: .app,
      sources: ["Example/**"],
      dependencies: [
        .target(name: MacFeatureModule.MacAddLinkFeature.rawValue),
        .core()
      ]
    ),
    Target.target(
      name: "\(MacFeatureModule.MacAddLinkFeature.rawValue)Tests",
      destinations: [.mac],
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: MacFeatureModule.MacAddLinkFeature.rawValue),
        .core()
      ]
    )
  ]
)
