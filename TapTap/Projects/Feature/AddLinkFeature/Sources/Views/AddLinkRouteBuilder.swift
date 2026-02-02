//
//  AddLinkRouteBuilder.swift
//  Feature
//
//  Created by 홍 on 10/26/25.
//

import SwiftUI

import ComposableArchitecture
import LinkNavigator

import Domain
import Shared

public struct AddLinkRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.addLink.rawValue
    return .init(matchPath: matchPath) { navigator, item, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        let decodedItem: CopiedLink? = item.decoded()
        let linkURL = decodedItem?.url ?? ""
        AddLinkView(store: Store(initialState: AddLinkFeature.State(linkURL: linkURL)) {
          AddLinkFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
