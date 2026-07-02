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
  
  func updateNSView(_ nsView: NSView, context: Context) { }
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
            window.minSize = NSSize(width: 640, height: 450) // 최소 사이즈 설정
          }
        )
    }
    .windowStyle(.hiddenTitleBar)
    .defaultSize(width: 1280, height: 720)
  }
}
