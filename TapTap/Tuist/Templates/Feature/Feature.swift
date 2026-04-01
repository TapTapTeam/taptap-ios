//
//  Template.swift
//  Manifests
//
//  Created by 여성일 on 4/1/26.
//

import ProjectDescription

let iOSFeatureTemplate = Template(
  description: "Generate an iOS feature module",
  attributes: [
    .required("name")
  ],
  items: [
    .file(
      path: "Projects/Feature/{{ name }}Feature/Project.swift",
      templatePath: "project.stencil"
    ),
    .file(
      path: "Projects/Feature/{{ name }}Feature/Sources/{{ name }}View.swift",
      templatePath: "Sources.swift.stencil"
    ),
    .file(
      path: "Projects/Feature/{{ name }}Feature/Example/App.swift",
      templatePath: "ExampleApp.swift.stencil"
    ),
    .file(
      path: "Projects/Feature/{{ name }}Feature/Tests/{{ name }}Tests.swift",
      templatePath: "Tests.swift.stencil"
    ),
    .file(
      path: "Projects/Feature/{{ name }}Feature/Resources/Placeholder.swift",
      templatePath: "Placeholder.swift.stencil"
    )
  ]
)
