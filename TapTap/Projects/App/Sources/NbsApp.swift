import SwiftUI
import SwiftData

import Domain
import DesignSystem
import LinkNavigator

import ComposableArchitecture

@main
struct NbsApp: App {
  let store = Store(initialState: AppFeature.State()) {
    AppFeature()
  }
  
  let singleNavigator = SingleLinkNavigator(
    routeBuilderItemList: AppRouterGroup().routers(),
    dependency: AppDependency()
  )
  
  var body: some Scene {
    WindowGroup {
      AppView(store: store, singleNavigator: singleNavigator)
    }
  }
}
