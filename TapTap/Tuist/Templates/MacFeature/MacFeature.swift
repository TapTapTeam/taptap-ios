//
//  Template.swift
//  Manifests
//
//  Created by 여성일 on 4/1/26.
//

import ProjectDescription

let macFeatureTemplate = Template(
  description: "Generate a macOS feature module",
  attributes: [
    .required("name")
  ],
  items: [
    .file(
      path: "Projects/MacFeature/{{ name }}Feature/Project.swift",
      templatePath: "project.stencil"
    ),
    .file(
      path: "Projects/MacFeature/{{ name }}Feature/Sources/{{ name }}View.swift",
      templatePath: "Sources.swift.stencil"
    ),
    .file(
      path: "Projects/MacFeature/{{ name }}Feature/Example/App.swift",
      templatePath: "ExampleApp.swift.stencil"
    ),
    .file(
      path: "Projects/MacFeature/{{ name }}Feature/Tests/{{ name }}Tests.swift",
      templatePath: "Tests.swift.stencil"
    ),
    .file(
      path: "Projects/MacFeature/{{ name }}Feature/Resources/Placeholder.swift",
      templatePath: "Placeholder.swift.stencil"
    )
  ]
)
