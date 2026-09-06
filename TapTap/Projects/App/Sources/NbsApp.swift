import SwiftUI
import SwiftData
import UIKit

import AnalyticsKit
import Core
import DesignSystem

import ComposableArchitecture

@main
struct NbsApp: App {
  /// Firebase는 다른 SDK보다 먼저, 앱 실행 초기에 configure되어야 자동 이벤트
  /// (`first_open`·`session_start`)를 놓치지 않는다. SwiftUI에서 그 시점은 `AppDelegate`다.
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

  let store = Store(initialState: AppFeature.State()) {
    AppFeature()
  }

  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      AppView(store: store)
        .ignoresSafeArea()
    }
    .onChange(of: scenePhase) { _, phase in
      guard phase == .active else { return }
      appDelegate.deliverPendingExtensionEvents()
    }
  }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
  @Dependency(\.analytics) private var analytics

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    analytics.start()
    analytics.setUserProperty(.deviceShell(UIDevice.current.userInterfaceIdiom == .pad ? "pad" : "phone"))
    deliverPendingExtensionEvents()
    return true
  }

  func deliverPendingExtensionEvents() {
    let queuedEvents = ExtensionAnalyticsQueue.drain()

    for queued in queuedEvents {
      analytics.track(
        ExtensionEvent(
          name: queued.name,
          properties: queued.properties,
          occurredAt: queued.occurredAt
        )
      )
    }

    if queuedEvents.contains(where: { $0.name == "highlight_created" }) {
      analytics.setUserProperty(.hasHighlighted(true))
    }
  }
}
