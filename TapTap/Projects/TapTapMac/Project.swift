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
      deploymentTargets: .macOS("15.0"),
      sources: .sources,
      resources: .default,
      entitlements: .file(path: "TapTapMac.entitlements"),
      dependencies: [
        .core(),
        .designSystem(),
        .macSearchFeature(),
        .macAddLinkFeature(),
        .macHomeFeature(),
        .macLinkListFeature()
      ]
    )
  ]
)
