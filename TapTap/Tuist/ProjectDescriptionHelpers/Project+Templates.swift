//
//  Project+Templates.swift
//  Manifests
//
//  Created by Hong on 10/6/25.
//

import ProjectDescription

extension Project {
  public static let macOSbundleID = "com.Nbs.dev.taptap.macOS"
  public static let macOSbundleIDAppStore = "com.Nbs.dev.ADA.macOS"
  public static let bundleIDBase = "com.Nbs.dev.app"
  public static let bundIDAppStore = "com.Nbs.dev.ADA.app"
  public static let iosVersion = "18.6"
  public static let appName = "TapTap"
}

extension Project {
  public static func project(
    name: String,
    targets: [Target] = [],
    additionalFiles: [FileElement] = []
  ) -> Project {
    Project(
      name: name,
      options: .options(
        textSettings: .textSettings(
          indentWidth: 2,
          tabWidth: 2,
          wrapsLines: true
        )
      ),
      targets: targets,
      additionalFiles: additionalFiles
    )
  }
}
