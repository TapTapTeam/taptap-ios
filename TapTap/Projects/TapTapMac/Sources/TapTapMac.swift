import Foundation
import SwiftUI
import SwiftData
import SwiftUI
import Core
import DesignSystem
import MacSearchFeature
import AppKit

final class FullScreenWindowDelegate: NSObject, NSWindowDelegate {
  func window(
    _ window: NSWindow,
    willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions
  ) -> NSApplication.PresentationOptions {
    proposedOptions.union(.autoHideToolbar)
  }
}

struct WindowAccessor: NSViewRepresentable {
  let onWindowAvailable: (NSWindow) -> Void
  
  func makeNSView(context: Context) -> NSView {
    let view = NSView()
    
    DispatchQueue.main.async {
      if let window = view.window {
        onWindowAvailable(window)
      }
    }
    
    return view
  }
  
  func updateNSView(_ nsView: NSView, context: Context) {
    DispatchQueue.main.async {
      if let window = nsView.window {
        onWindowAvailable(window)
      }
    }
  }
}

@main
struct MacApp: App {
  private let fullScreenDelegate = FullScreenWindowDelegate()
  
  @StateObject private var searchViewModel = SearchViewModel(
    searchService: DefaultSearchService(),
    recentService: DefaultRecentSearchService()
  )
  
  var body: some Scene {
    WindowGroup {
      RootView(searchViewModel: searchViewModel)
        .modelContainer(AppGroupContainer.shared)
        .background(
          WindowAccessor { window in
            window.delegate = fullScreenDelegate
          }
        )
    }
    .windowStyle(.hiddenTitleBar)
  }
}
