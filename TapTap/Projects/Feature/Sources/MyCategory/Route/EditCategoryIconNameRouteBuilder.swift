//
//  EditCategoryIconNameRouteBuilder.swift
//  Feature
//
//  Created by 홍 on 10/27/25.
//

import SwiftData

import ComposableArchitecture
import LinkNavigator

import Domain

public struct EditCategoryIconNameRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    
    let matchPath = Route.editCategoryNameIcon.rawValue
    
    return .init(matchPath: matchPath) { navigator, item, dependency -> RouteViewController? in
      let query: CategoryItem? = item.decoded()
      
      return WrappingController(matchPath: matchPath) {
        EditCategoryIconNameView(store: Store(initialState: EditCategoryIconNameFeature.State(category: query)) {
          EditCategoryIconNameFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
