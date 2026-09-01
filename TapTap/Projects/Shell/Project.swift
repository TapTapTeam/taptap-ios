//
//  Project.swift
//  Shell
//
//  Created by Hong on 9/1/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

// 사이드바 + 링크 목록 + 상세로 구성된 넓은 화면 셸이다.
// macOS 앱(TapTapMac)과 iPad(App 타겟)가 같은 화면을 공유한다.
let project = Project.project(
  name: Module.Shell.rawValue,
  targets: [
    Target.target(
      name: Module.Shell.rawValue,
      destinations: [.iPhone, .iPad, .mac],
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .core(),
        .designSystem(),
        .macSearchFeature(),
        .macAddLinkFeature(),
        .macLinkListFeature(),
        .macLinkDetailFeature()
      ]
    )
  ]
)
