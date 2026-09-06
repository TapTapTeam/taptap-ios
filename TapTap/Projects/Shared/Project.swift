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
        .core(),
        // 모든 Feature가 이미 .shared()를 물고 있다. 계측은 어느 피처에서든 필요하므로
        // 여기 한 번만 걸어 피처마다 Project.swift를 고치지 않게 한다.
        // (익스텐션들은 .core()만 쓰므로 Firebase·Amplitude가 딸려가지 않는다)
        .analyticsKit()
      ]
    )
  ]
)
