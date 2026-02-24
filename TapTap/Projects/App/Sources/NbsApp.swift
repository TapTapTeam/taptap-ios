import SwiftUI
import SwiftData

import Core
import DesignSystem

import ComposableArchitecture

@main
struct NbsApp: App {
  let store = Store(initialState: AppFeature.State()) {
    AppFeature()
  }
  
  var body: some Scene {
    WindowGroup {
      AppView(store: store)
    }
  }
}
