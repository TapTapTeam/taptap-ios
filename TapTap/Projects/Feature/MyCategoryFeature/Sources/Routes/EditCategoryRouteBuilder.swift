//
//  editCategoryRouteBuilder.swift
//  Feature
//
//  Created by 홍 on 10/27/25.
//

import ComposableArchitecture
import LinkNavigator

import Shared

public struct EditCategoryRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.editCategory.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        EditCategoryView(store: Store(initialState: EditCategoryFeature.State()) {
          EditCategoryFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
