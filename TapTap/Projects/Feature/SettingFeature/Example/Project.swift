//
//  Project.swift
//  Manifests
//
//  Created by Hong on 1/23/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let target = Target.target(
  name: "\(FeatureModule.SettingFeature.rawValue)Example",
  product: .app,
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: .default,
)

let project = Project.project(
  name: "\(FeatureModule.SettingFeature.rawValue)Example",
  targets: [
    target
  ]
)
