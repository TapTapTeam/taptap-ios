import SwiftUI
import SwiftData
import UIKit

import Core
import DesignSystem
import MacSearchFeature
import Shell

import ComposableArchitecture

@main
struct NbsApp: App {
  let store = Store(initialState: AppFeature.State()) {
    AppFeature()
  }

  /// iPad는 macOS 앱과 같은 셸(사이드바 + 목록 + 상세)을 쓴다. 검색 뷰모델도 그쪽 것을 그대로 쓴다.
  @StateObject private var searchViewModel = SearchViewModel(
    searchService: DefaultSearchService(),
    recentService: DefaultRecentSearchService()
  )

  private var isPad: Bool {
    UIDevice.current.userInterfaceIdiom == .pad
  }

  var body: some Scene {
    WindowGroup {
      if isPad {
        RootView(searchViewModel: searchViewModel)
          .modelContainer(AppGroupContainer.shared)
      } else {
        AppView(store: store)
          .ignoresSafeArea()
      }
    }
  }
}
