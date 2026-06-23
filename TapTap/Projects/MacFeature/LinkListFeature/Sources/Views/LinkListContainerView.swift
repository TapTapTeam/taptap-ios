//
//  LinkListContainerView.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import SwiftUI

import Core
import MacLinkDetailFeature
import SwiftData

/// 링크 리스트의 편집, 삭제, 이동 플로우를 관리하는 컨테이너 뷰입니다.
public struct LinkListContainerView: View {
  @Environment(\.modelContext) private var modelContext
  
  private let articles: [ArticleItem]
  private let categories: [CategoryItem]
  private let selectedCategoryID: UUID?
  private let isSeeAllSelected: Bool
  @Binding private var isEditing: Bool

  @State private var viewModel = LinkListViewModel()
  @State private var detailViewModel: LinkDetailViewModel?
  
  public init(
    articles: [ArticleItem],
    categories: [CategoryItem],
    selectedCategoryID: UUID?,
    isSeeAllSelected: Bool,
    isEditing: Binding<Bool>
  ) {
    self.articles = articles
    self.categories = categories
    self.selectedCategoryID = selectedCategoryID
    self.isSeeAllSelected = isSeeAllSelected
    self._isEditing = isEditing
  }
  
  public var body: some View {
    ZStack {
      if let detailViewModel {
        detailContent(detailViewModel)
          .transition(.move(edge: .trailing).combined(with: .opacity))
      } else {
        listContent
          .transition(.opacity)
      }
    }
    .overlay(alignment: .top) {
      VStack(spacing: 12) {
        if let moveToast = viewModel.moveToast {
          LinkActionToast(
            variant: .move,
            count: moveToast.movedCount,
            title: moveToast.categoryName,
            duration: 3,
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
            duration: 3,
            onUndoTap: viewModel.undoDelete,
            onCloseTap: viewModel.commitPendingDelete
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
    .onChange(of: selectedCategoryID) { _, _ in
      updateViewModel()
      viewModel.handleCategoryContextChange()
    }
    .onChange(of: isSeeAllSelected) { _, _ in
      updateViewModel()
      viewModel.handleCategoryContextChange()
    }
    .onChange(of: viewModel.isEditing) { _, newValue in
      isEditing = newValue
    }
    .onChange(of: viewModel.selectedTabID) { _, _ in
      syncDetailViewModel()
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
        .popover(
          isPresented: multiMovePickerBinding,
          arrowEdge: .bottom
        ) {
          LinkMovePopover(
            categories: categories,
            selectedCategoryID: selectedCategoryID,
            onSelect: viewModel.moveSelectedLinks
          )
        }
      }

      LinkListView(
        viewModel: viewModel,
        onArticleTap: openArticle,
        onMoveTap: viewModel.presentSingleMovePicker,
        onDeleteTap: viewModel.requestDeleteSingleLink,
        onEditTap: viewModel.beginEditing
      )
      .popover(
        isPresented: singleMovePickerBinding,
        arrowEdge: .leading
      ) {
        LinkMovePopover(
          categories: categories,
          selectedCategoryID: viewModel.movingArticle?.category?.id,
          onSelect: viewModel.moveSingleLink
        )
      }
    }
  }

  func detailContent(_ detailViewModel: LinkDetailViewModel) -> some View {
    VStack(spacing: 0) {
      if !viewModel.openedTabs.isEmpty {
        LinkTabBar(
          tabs: viewModel.openedTabs,
          selectedTabID: viewModel.selectedTabID,
          onSelect: selectTab,
          onClose: closeTab
        )
      }

      LinkDetailView(viewModel: detailViewModel)
        .onChange(of: detailViewModel.isDeleted) { _, isDeleted in
          guard isDeleted else { return }
          closeTab(detailViewModel.article.id)
        }
    }
  }

  var multiMovePickerBinding: Binding<Bool> {
    Binding(
      get: { viewModel.isMultiMovePickerPresented },
      set: { isPresented in
        if !isPresented {
          viewModel.dismissMultiMovePicker()
        }
      }
    )
  }

  var singleMovePickerBinding: Binding<Bool> {
    Binding(
      get: { viewModel.isSingleMovePickerPresented },
      set: { isPresented in
        if !isPresented {
          viewModel.dismissSingleMovePicker()
        }
      }
    )
  }

  func updateViewModel() {
    viewModel.update(
      articles: articles,
      categories: categories,
      selectedCategoryID: selectedCategoryID,
      isSeeAllSelected: isSeeAllSelected
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
