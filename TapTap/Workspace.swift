//
//  Workspace.swift
//  Manifests
//
//  Created by Hong on 10/5/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
  name: "TapTap",
  projects: [
    "Projects/*",
    //"Projects/Feature/*",
  ]
  + FeatureModule.allCases.map { "Projects/Feature/\($0.rawValue)/*" }
)
