//
//  Project.swift
//  Manifests
//
//  Created by 여성일 on 1/26/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: ClientModule.MyCategoryClient.rawValue,
  targets: [
    Target.target(
      name: ClientModule.MyCategoryClient.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .TCA(),
        .domain(),
      ]
    ),
    Target.target(
      name: "\(ClientModule.MyCategoryClient.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: ClientModule.MyCategoryClient.rawValue),
        .TCA()
      ]
    )
  ]
)
