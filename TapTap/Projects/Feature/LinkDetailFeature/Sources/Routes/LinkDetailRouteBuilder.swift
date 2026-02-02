//
//  LinkDetailRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 10/28/25.
//

import ComposableArchitecture
import LinkNavigator

import Core
import Shared

public struct LinkDetailRouteBuilder {
  
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.linkDetail.rawValue
    return .init(matchPath: matchPath) { navigator, item, _ -> RouteViewController? in
      
      let query: ArticleItem? = item.decoded()
  
      return WrappingController(matchPath: matchPath) {
        LinkDetailView(store: Store(initialState: LinkDetailFeature.State(article: query!)) {
          LinkDetailFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
