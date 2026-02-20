//
//  SwiftData.Dependency.swift
//  Shared
//
//  Created by 여성일 on 2/2/26.
//

import Foundation
import SwiftData
import ComposableArchitecture

import Core

public struct SwiftDataClient {
  public var link: LinkRepository
  public var category: CategoryRepository
  public var highlight: HighlightRepository
}

extension SwiftDataClient: DependencyKey {
  public static let liveValue: Self = {
    let conainer = AppGroupContainer.shared
    let context = ModelContext(conainer)
    
    return Self(
      link: LinkRepository(context: context),
      category: CategoryRepository(context: context),
      highlight: HighlightRepository(context: context)
    )
  }()
}

extension DependencyValues {
  public var swiftDataClient: SwiftDataClient {
    get { self[SwiftDataClient.self] }
    set { self[SwiftDataClient.self] = newValue }
  }
}
