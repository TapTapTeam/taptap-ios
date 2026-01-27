//
//  Project.swift
//  Manifests
//
//  Created by 여성일 on 1/26/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: ClientModule.HomeClient.rawValue,
  targets: [
    Target.target(
      name: ClientModule.HomeClient.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .TCA(),
        .domain(),
      ]
    ),
    Target.target(
      name: "\(ClientModule.HomeClient.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: ClientModule.HomeClient.rawValue),
        .TCA()
      ]
    )
  ]
)
