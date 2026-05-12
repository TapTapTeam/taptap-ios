//
//  Project.swift
//  MacLinkDetailFeature
//
//  Created by TapTap on 5/11/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: MacFeatureModule.MacLinkDetailFeature.rawValue,
  targets: [
    Target.target(
      name: MacFeatureModule.MacLinkDetailFeature.rawValue,
      destinations: [.mac],
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .core(),
        .designSystem()
      ]
    ),
    Target.target(
      name: "\(MacFeatureModule.MacLinkDetailFeature.rawValue)Example",
      destinations: [.mac],
      product: .app,
      sources: ["Example/**"],
      dependencies: [
        .target(name: MacFeatureModule.MacLinkDetailFeature.rawValue),
        .core()
      ]
    ),
    Target.target(
      name: "\(MacFeatureModule.MacLinkDetailFeature.rawValue)Tests",
      destinations: [.mac],
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: MacFeatureModule.MacLinkDetailFeature.rawValue),
        .core()
      ]
    )
  ]
)
