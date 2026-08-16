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

  @State private var editMenuArticleID: String?

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
    .frame(maxWidth: viewModel.isEditing ? 663 : 640)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .overlayPreferenceValue(MacEditMenuAnchorKey.self) { anchor in
      if let anchor, let article = editMenuArticle {
        GeometryReader { proxy in
          editMenuOverlay(for: article, anchorRect: proxy[anchor])
        }
      }
    }
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
            linkURL: article.urlString,
            dateString: viewModel.formattedDate(article.createAt),
            isEditing: viewModel.isEditing,
            isSelected: isSelected,
            isEditMenuPresented: editMenuArticleID == article.id,
            onCardTap: {
              onArticleTap(article)
            },
            onEditButtonTap: {
              editMenuArticleID = article.id
            }
          )
          .frame(maxWidth: viewModel.isEditing ? 615 : 600)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 24)
      .padding(.top, 4)
      .padding(.bottom, 24)
    }
  }

  var editMenuArticle: ArticleItem? {
    guard let editMenuArticleID else { return nil }
    return viewModel.displayedArticles.first { $0.id == editMenuArticleID }
  }

  func editMenuOverlay(for article: ArticleItem, anchorRect: CGRect) -> some View {
    ZStack(alignment: .topLeading) {
      Color.clear
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
          editMenuArticleID = nil
        }

      MacPopup(
        normalImage: DesignSystemAsset.openWindow.swiftUIImage,
        normalTitle: "링크 이동하기",
        dangerImage: DesignSystemAsset.trash.swiftUIImage,
        dangerTitle: "링크 삭제하기",
        onNormalTap: {
          editMenuArticleID = nil
          onMoveTap(article)
        },
        onDangerTap: {
          editMenuArticleID = nil
          onDeleteTap(article)
        }
      )
      .offset(x: anchorRect.minX, y: anchorRect.minY)
    }
  }
}
