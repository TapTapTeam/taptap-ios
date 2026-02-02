//
//  AddNewCategoryRouteBuilder.swift
//  Feature
//
//  Created by 홍 on 10/26/25.
//

import ComposableArchitecture
import LinkNavigator

import Shared

public struct AddCategoryRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.addCategory.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        AddCategoryView(store: Store(initialState: AddCategoryFeature.State()) {
          AddCategoryFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
