//
//  Project.swift
//  Manifests
//
//  Created by Hong on 12/30/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.TapTapMac.rawValue,
  targets: [
    Target.target(
      name: Module.TapTapMac.rawValue,
      destinations: .macOS,
      product: .app,
      bundleId: "com.Nbs.dev.mac",
      infoPlist: .extendingDefault(with: [:]),
      sources: .sources,
      resources: .default,
      dependencies: [
        .TCA(),
      ]
    )
  ]
)
