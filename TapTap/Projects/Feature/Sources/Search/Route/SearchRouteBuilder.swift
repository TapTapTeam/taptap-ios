//
//  SearchRouteBuilder.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import ComposableArchitecture
import LinkNavigator

public struct SearchRouteBuilder {
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.search.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
          SearchFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        }))
      }
    }
  }
}
