//
//  Project.swift
//  Manifests
//
//  Created by 여성일 on 1/26/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: ClientModule.LinkListClient.rawValue,
  targets: [
    Target.target(
      name: ClientModule.LinkListClient.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .TCA(),
        .domain(),
      ]
    ),
    Target.target(
      name: "\(ClientModule.LinkListClient.rawValue)Tests",
      product: .unitTests,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: ClientModule.LinkListClient.rawValue),
        .TCA()
      ]
    )
  ]
)
