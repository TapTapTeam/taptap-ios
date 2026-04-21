import Foundation
import SwiftUI
import SwiftData
import Core
import DesignSystem

@main
struct MacApp: App {
  var body: some Scene {
    WindowGroup {
      MACContentView()
        .modelContainer(AppGroupContainer.shared)
    }
  }
}

public struct TapTapMac {
  public init() {}
}

struct MACContentView: View {
  @Query private var articles: [ArticleItem]

  var body: some View {
    NavigationView {
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
      .navigationTitle("저장된 링크 (CloudKit 연동)")
    }
  }
}
