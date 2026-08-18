//
//  LinkListContainerView.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import SwiftUI

import Core
import DesignSystem
import MacLinkDetailFeature
import SwiftData

/// 링크 리스트의 편집, 삭제, 이동 플로우를 관리하는 컨테이너 뷰입니다.
public struct LinkListContainerView: View {
  @Environment(\.modelContext) private var modelContext
  
  private let articles: [ArticleItem]
  private let categories: [CategoryItem]
  private let viewModel: LinkListViewModel
  @Binding private var isEditing: Bool

  @State private var detailViewModel: LinkDetailViewModel?
  
  public init(
    articles: [ArticleItem],
    categories: [CategoryItem],
    viewModel: LinkListViewModel,
    isEditing: Binding<Bool>
  ) {
    self.articles = articles
    self.categories = categories
    self.viewModel = viewModel
    self._isEditing = isEditing
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      if !viewModel.openedTabs.isEmpty {
        LinkTabBar(
          tabs: viewModel.openedTabs,
          selectedTabID: viewModel.selectedTabID,
          onSelect: selectTab,
          onClose: closeTab,
          onNewTab: beginNewTabSelection
        )
      }

      ZStack {
        if let detailViewModel {
          detailContent(detailViewModel)
            .transition(.move(edge: .trailing).combined(with: .opacity))
        } else {
          listContent
            .transition(.opacity)
            .padding(.top, 20)
        }
      }
    }
    .overlay(alignment: .top) {
      VStack(spacing: 12) {
        if let moveToast = viewModel.moveToast {
          LinkActionToast(
            variant: .move,
            count: moveToast.movedCount,
            title: moveToast.categoryName,
            duration: 5,
            onUndoTap: viewModel.undoMove,
            onCloseTap: viewModel.hideMoveToast
          )
          .transition(.move(edge: .top).combined(with: .opacity))
        }
        
        if let deleteToast = viewModel.deleteToast {
          LinkActionToast(
            variant: .delete,
            count: deleteToast.deletedCount,
            title: deleteToast.linkTitle,
            duration: 5,
            onUndoTap: viewModel.undoDelete,
            onCloseTap: viewModel.commitPendingDelete
          )
          .transition(.move(edge: .top).combined(with: .opacity))
        }

        if let articleDeleteToast = viewModel.articleDeleteToast {
          LinkActionToast(
            variant: .delete,
            message: articleDeleteToast.message,
            duration: 3,
            onUndoTap: nil,
            onCloseTap: viewModel.hideArticleDeleteToast
          )
          .transition(.move(edge: .top).combined(with: .opacity))
        }
      }
      .padding(.horizontal, 40)
      .padding(.top, 20)
      .zIndex(10)
    }
    .animation(.easeInOut(duration: 0.2), value: viewModel.moveToast?.id)
    .animation(.easeInOut(duration: 0.2), value: viewModel.deleteToast?.id)
    .animation(.easeInOut(duration: 0.2), value: viewModel.articleDeleteToast?.id)
    .onAppear {
      viewModel.updatePersistence(SwiftDataLinkListPersistence(modelContext: modelContext))
      updateViewModel()
    }
    .onChange(of: articles.map { "\($0.id):\($0.category?.id.uuidString ?? "")" }) { _, _ in
      updateViewModel()
    }
    .onChange(of: categories.map { "\($0.id):\($0.categoryName):\($0.isFavorite)" }) { _, _ in
      updateViewModel()
    }
    .onChange(of: viewModel.activeContext) { _, _ in
      syncDetailViewModel()
    }
    .onChange(of: viewModel.isEditing) { _, newValue in
      isEditing = newValue
    }
    .onDisappear {
      viewModel.dismiss()
    }
  }
}

private extension LinkListContainerView {
  var listContent: some View {
    VStack(spacing: 0) {
      if isEditing {
        LinkEditToolbar(
          selectedCount: viewModel.selectedArticleIDs.count,
          onCancel: viewModel.endEditing,
          onDelete: viewModel.requestDeleteSelectedLinks,
          onMove: viewModel.presentMultiMovePicker
        )
      }

      LinkListView(
        viewModel: viewModel,
        onArticleTap: openArticle,
        onMoveTap: viewModel.presentSingleMovePicker,
        onDeleteTap: viewModel.requestDeleteSingleLink,
        onEditTap: viewModel.beginEditing
      )
    }
  }

  func detailContent(_ detailViewModel: LinkDetailViewModel) -> some View {
    LinkDetailView(viewModel: detailViewModel)
      .onChange(of: detailViewModel.isDeleted) { _, isDeleted in
        guard isDeleted else { return }
        viewModel.showArticleDeleteToast(title: detailViewModel.article.title)
        viewModel.closeTabs(articleIDs: [detailViewModel.article.id])
        syncDetailViewModel()
      }
  }

  func updateViewModel() {
    viewModel.update(
      articles: articles,
      categories: categories
    )
    syncDetailViewModel()
  }

  func openArticle(_ article: ArticleItem) {
    viewModel.openArticle(article)
    syncDetailViewModel()
  }

  func selectTab(_ tabID: String) {
    viewModel.selectTab(tabID)
    syncDetailViewModel()
  }

  func closeTab(_ tabID: String) {
    viewModel.closeTab(tabID)
    syncDetailViewModel()
  }

  func beginNewTabSelection() {
    viewModel.beginNewTabSelection()
    syncDetailViewModel()
  }

  func syncDetailViewModel() {
    guard let selectedArticle = viewModel.selectedArticle else {
      detailViewModel = nil
      return
    }

    let persistence = SwiftDataLinkDetailPersistence(modelContext: modelContext)
    if let detailViewModel, detailViewModel.article.id == selectedArticle.id {
      detailViewModel.updateArticle(selectedArticle)
      detailViewModel.updatePersistence(persistence)
    } else {
      detailViewModel = LinkDetailViewModel(
        article: selectedArticle,
        persistence: persistence
      )
    }
  }
}
