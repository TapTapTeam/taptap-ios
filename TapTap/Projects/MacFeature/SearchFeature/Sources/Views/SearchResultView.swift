//
//  SearchResultView.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import DesignSystem
import Core

public struct SearchResultView: View {
  private let items: [ArticleItem]
  private let onTap: (ArticleItem) -> Void
  
  public init(
    items: [ArticleItem],
    onTap: @escaping (ArticleItem) -> Void
  ) {
    self.items = items
    self.onTap = onTap
  }
}

public extension SearchResultView {
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 8) {
        ForEach(items) { item in
          SearchResultCard(
            title: item.title,
            date: formattedDate(item.createAt),
            category: item.category?.categoryName ?? "-",
            image: item.imageURL ?? "",
            action: {
              onTap(item)
            }
          )
        }
      }
    }
  }
}

private extension SearchResultView {
  func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.string(from: date)
  }
}
