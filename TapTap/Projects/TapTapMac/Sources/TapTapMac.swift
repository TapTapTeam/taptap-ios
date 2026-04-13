import Foundation
import SwiftUI
import SwiftData
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
  
  var body: some Scene {
    WindowGroup {
      RootView()
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

struct MACContentView: View {
  let articles: [ArticleItem]
  @ObservedObject var searchViewModel: SearchViewModel
  @State private var isSearchOverlayPresented: Bool = false

  var body: some View {
    HSplitView {
      sidebar
        .frame(width: 0)
      
      VStack(spacing: 0) {
        MacToolbar(
          text: $searchViewModel.query,
          onSearchTap: {
            isSearchOverlayPresented = true
            searchViewModel.focus()
          }
        )

        SearchView(viewModel: searchViewModel)
      }
      .ignoresSafeArea(edges: .top)
    }
//    NavigationSplitView {
//      sidebar
//        .background(
//          Color.background
//        )
//    } detail: {
//      ZStack(alignment: .top) {
//        VStack(spacing: 0) {
//          MacToolbar(
//            text: $searchViewModel.query,
//            onSearchTap: {
//              isSearchOverlayPresented = true
//              searchViewModel.focus()
//            }
//          )
//
//          SearchView(viewModel: searchViewModel)
//        }
//
//        if isSearchOverlayPresented {
//          Color.black.opacity(0.16)
//            .contentShape(Rectangle())
//            .onTapGesture {
//              isSearchOverlayPresented = false
//            }
//
//          SearchDropdownPanel(
//            viewModel: searchViewModel,
//            onClose: {
//              isSearchOverlayPresented = false
//            }
//          )
//            .zIndex(10)
//        }
//      }
//      .ignoresSafeArea(edges: .top)
//    }
  }

  private var sidebar: some View {
    List(articles) { article in
      VStack(alignment: .leading, spacing: 4) {
        Text(article.title)
          .font(.B1_M)

        Text(article.urlString)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .padding(.vertical, 4)
    }
    .navigationSplitViewColumnWidth(min: 240, ideal: 280, max: 360)
  }
}
