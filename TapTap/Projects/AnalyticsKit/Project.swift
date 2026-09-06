//
//  Project.swift
//  Manifests
//
//  Created by 홍 on 9/5/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.AnalyticsKit.rawValue,
  targets: [
    Target.target(
      name: Module.AnalyticsKit.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .TCA(),
        .FirebaseAnalytics(),
        .Amplitude()
      ]
    ),
    Target.target(
      name: "\(Module.AnalyticsKit.rawValue)Tests",
      product: .unitTests,
      sources: .tests,
      dependencies: [
        .target(name: Module.AnalyticsKit.rawValue)
      ]
    )
  ]
)
