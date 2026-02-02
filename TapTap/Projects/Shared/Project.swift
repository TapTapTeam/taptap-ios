//
//  Project.swift
//  Manifests
//
//  Created by 여성일 on 2/2/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.Shared.rawValue,
  targets: [
    Target.target(
      name: Module.Shared.rawValue,
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .TCA(),
        .LinkNavigator(),
        .domain()
      ]
    )
  ]
)
