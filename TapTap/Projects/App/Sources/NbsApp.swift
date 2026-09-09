import SwiftUI
import SwiftData
import UIKit

import AnalyticsKit
import Core
import DesignSystem

import ComposableArchitecture

@main
struct NbsApp: App {
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
      appDelegate.deliverPendingExtensionEvents(trigger: .foreground)
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
    deliverPendingExtensionEvents(trigger: .appLaunch)
    return true
  }

  func deliverPendingExtensionEvents(trigger: ExtensionEvent.DeliveryTrigger) {
    let queuedEvents = ExtensionAnalyticsQueue.drain()

    for queued in queuedEvents {
      analytics.track(
        ExtensionEvent(
          name: queued.name,
          properties: queued.properties,
          occurredAt: queued.occurredAt,
          deliveredBy: trigger
        )
      )
    }

    if queuedEvents.contains(where: { $0.name == "highlight_created" }) {
      analytics.setUserProperty(.hasHighlighted(true))
    }
  }
}
