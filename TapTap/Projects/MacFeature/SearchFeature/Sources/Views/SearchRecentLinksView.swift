//
//  SearchRecentLinksView.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/27/26.
//

import SwiftUI
import DesignSystem
import Core

public struct SearchRecentLinksView: View {
  private let items: [ArticleItem]
  private let onTap: (ArticleItem) -> Void

  private let columns = [
    GridItem(.fixed(296), spacing: 8),
    GridItem(.fixed(296), spacing: 8)
  ]

  public init(
    items: [ArticleItem],
    onTap: @escaping (ArticleItem) -> Void,
  ) {
    self.items = items
    self.onTap = onTap
  }
}

public extension SearchRecentLinksView {
  var body: some View {
    VStack(alignment: .leading) {
      Divider()
        .padding(.horizontal, -20) // 상위 뷰에서 20만큼 패딩을 주고 있기 때문에 -20 처리
        .padding(.bottom, 12)
      
      HStack {
        Text("최근 본 링크")
          .font(.B2_M)
          .foregroundStyle(.caption2)
      }
      .padding(.top, 8)
      .padding(.bottom, 16)
      
      LazyVGrid(columns: columns, spacing: 8) {
        ForEach(items, id: \.id) { item in
          SearchRecentLinksCard(
            title: item.title,
            image: item.imageURL,
            onTap: { onTap(item) }
          )
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
