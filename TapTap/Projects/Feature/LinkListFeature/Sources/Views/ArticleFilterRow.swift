//
//  ArticleFilterRow.swift
//  Feature
//
//  Created by 이안 on 10/27/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import Core

struct ArticleRowView: View, Equatable {
  let article: ArticleItem
//  @Bindable var store: StoreOf<ArticleFilterFeature>
  let onTap: () -> Void
  let onLongPress: () -> Void
  @State private var didLongPress = false
  
  static func == (lhs: ArticleRowView, rhs: ArticleRowView) -> Bool {
    lhs.article.id == rhs.article.id &&
    lhs.article.title == rhs.article.title &&
    lhs.article.imageURL == rhs.article.imageURL &&
    lhs.article.category?.categoryName == rhs.article.category?.categoryName
  }

  var body: some View {
    ArticleCard(
      title: article.title,
      categoryName: article.category?.categoryName ?? "전체",
      imageURL: article.imageURL ?? "notImage",
      dateString: article.createAt.formattedKoreanDate()
    )
    .contentShape(Rectangle())
    .background(Color.clear)
    .simultaneousGesture(
      TapGesture().onEnded {
        if !didLongPress {
//          store.send(.listCellTapped(article))
          onTap()
        }
        didLongPress = false
      }
    )
    .simultaneousGesture(
      LongPressGesture(minimumDuration: 0.5)
        .onEnded { _ in
          didLongPress = true
//          store.send(.listCellLongPressed(article))
          onLongPress()
        }
    )
    .padding(.bottom, 10)
  }
}
