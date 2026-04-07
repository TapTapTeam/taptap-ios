import SwiftData
import SwiftUI
import Core
import MacHomeFeature

@main
struct MacApp: App {
  var body: some Scene {
    WindowGroup {
      HomeView()
        .modelContainer(AppGroupContainer.shared)
    }
  }
}

public struct TapTapMac {
  public init() {}
}
