//
//  LinkListView.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import SwiftUI

import Core
import DesignSystem

/// 링크 목록, 목록 헤더, 빈 화면을 표시하는 뷰입니다.
public struct LinkListView: View {
  @Bindable private var viewModel: LinkListViewModel

  private let onArticleTap: (ArticleItem) -> Void
  private let onMoveTap: (ArticleItem) -> Void
  private let onDeleteTap: (ArticleItem) -> Void
  private let onEditTap: () -> Void
  
  public init(
    viewModel: LinkListViewModel,
    onArticleTap: @escaping (ArticleItem) -> Void = { _ in },
    onMoveTap: @escaping (ArticleItem) -> Void = { _ in },
    onDeleteTap: @escaping (ArticleItem) -> Void = { _ in },
    onEditTap: @escaping () -> Void = {}
  ) {
    self.viewModel = viewModel
    self.onArticleTap = onArticleTap
    self.onMoveTap = onMoveTap
    self.onDeleteTap = onDeleteTap
    self.onEditTap = onEditTap
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      LinkListHeaderView(
        categoryTitle: viewModel.categoryTitle,
        selectedOrder: viewModel.sortOrder,
        isEditing: viewModel.isEditing,
        totalCount: viewModel.displayedArticles.count,
        isAllSelected: viewModel.isAllDisplayedArticlesSelected,
        onSortOrderSelect: viewModel.selectSortOrder,
        onToggleSelectAll: viewModel.toggleSelectAll,
        onEditTap: onEditTap
      )
      
      if viewModel.displayedArticles.isEmpty {
        LinkListEmptyView()
      } else {
        articleList
      }
    }
    .frame(maxWidth: 640)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
}

private extension LinkListView {
  var articleList: some View {
    ScrollView {
      LazyVStack(spacing: 8) {
        ForEach(viewModel.displayedArticles) { article in
          let isSelected = Binding<Bool>(
            get: {
              viewModel.selectedArticleIDs.contains(article.id)
            },
            set: { newValue in
              viewModel.updateSelection(article, isSelected: newValue)
            }
          )
          
          MacArticleCard(
            title: article.title,
            categoryName: article.category?.categoryName,
            imageURL: article.imageURL,
            dateString: viewModel.formattedDate(article.createAt),
            isEditing: viewModel.isEditing,
            isSelected: isSelected,
            onCardTap: {
              onArticleTap(article)
            },
            onMoveTap: {
              onMoveTap(article)
            },
            onDeleteTap: {
              onDeleteTap(article)
            }
          )
          .frame(maxWidth: viewModel.isEditing ? 570 : 600)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 20)
      .padding(.bottom, 24)
    }
  }
}
