//
//  LinkListViewModel.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import Foundation
import Observation

import Core

/// 링크 리스트 화면의 필터링, 정렬, 선택 상태를 관리하는 ViewModel입니다.
@MainActor
@Observable
public final class LinkListViewModel {
  public enum SortOrder {
    case latest
    case oldest
  }

  public struct MoveToastState: Identifiable {
    public let id = UUID()
    public let movedCount: Int
    public let categoryName: String?
    fileprivate let snapshots: [MovedArticleSnapshot]
  }

  public struct DeleteToastState: Identifiable {
    public let id = UUID()
    public let deletedCount: Int
    public let linkTitle: String?
  }

  public struct OpenedLinkTab: Identifiable, Equatable {
    public let id: String
    public let title: String

    init(article: ArticleItem) {
      self.id = article.id
      self.title = article.title
    }
  }

  fileprivate struct MovedArticleSnapshot {
    let articleID: String
    let previousCategory: CategoryItem?
  }

  public private(set) var displayedArticles: [ArticleItem] = []
  public private(set) var isAllDisplayedArticlesSelected: Bool = false
  public private(set) var hiddenArticleIDs: Set<String> = []
  public private(set) var isMultiMovePickerPresented: Bool = false
  public private(set) var isSingleMovePickerPresented: Bool = false
  public private(set) var movingArticle: ArticleItem?
  public private(set) var isDeleteAlertPresented: Bool = false
  public private(set) var moveToast: MoveToastState?
  public private(set) var deleteToast: DeleteToastState?
  public private(set) var openedTabs: [OpenedLinkTab] = []
  public private(set) var selectedTabID: String?

  public var isEditing: Bool = false
  public var selectedArticleIDs: Set<String> = [] {
    didSet {
      updateSelectionState()
    }
  }

  public var sortOrder: SortOrder = .latest {
    didSet {
      applyFilters()
    }
  }

  private var articles: [ArticleItem] = []
  private var categories: [CategoryItem] = []
  private var selectedCategoryID: UUID?
  private var isSeeAllSelected: Bool = true
  private var pendingDeleteArticles: [ArticleItem] = []
  private var pendingDeletedArticles: [ArticleItem] = []
  private var persistence: (any LinkListPersistence)?

  @ObservationIgnored private var moveToastDismissTask: Task<Void, Never>?
  @ObservationIgnored private var deleteToastDismissTask: Task<Void, Never>?

  public init() {}

  deinit {
    moveToastDismissTask?.cancel()
    deleteToastDismissTask?.cancel()
  }

  public func updatePersistence(_ persistence: any LinkListPersistence) {
    self.persistence = persistence
  }

  public func update(
    articles: [ArticleItem],
    categories: [CategoryItem],
    selectedCategoryID: UUID?,
    isSeeAllSelected: Bool
  ) {
    self.articles = articles
    self.categories = categories
    self.selectedCategoryID = selectedCategoryID
    self.isSeeAllSelected = isSeeAllSelected
    self.hiddenArticleIDs = Set(pendingDeletedArticles.map(\.id))
    applyFilters()
  }

  public func selectSortOrder(_ sortOrder: SortOrder) {
    self.sortOrder = sortOrder
  }

  public var categoryTitle: String {
    if isSeeAllSelected {
      return "전체"
    }

    return categories
      .first { $0.id == selectedCategoryID }?
      .categoryName ?? "전체"
  }

  public var selectedArticle: ArticleItem? {
    guard let selectedTabID else { return nil }
    return articles.first { $0.id == selectedTabID }
  }

  public var deleteAlertTitle: String {
    if pendingDeleteArticles.count > 1 {
      return "\(pendingDeleteArticles.count)개의 링크를 삭제할까요?"
    }

    return "선택한 링크를 삭제할까요?"
  }

  public func formattedDate(_ date: Date) -> String {
    DateFormatter.articleDateFormatter.string(from: date)
  }

  public func updateSelectionState() {
    isAllDisplayedArticlesSelected = !displayedArticles.isEmpty
    && displayedArticles.allSatisfy { selectedArticleIDs.contains($0.id) }
  }

  public func selectedAllDisplayedArticleIDs() -> Set<String> {
    Set(displayedArticles.map(\.id))
  }

  public func beginEditing() {
    selectedArticleIDs.removeAll()
    isSingleMovePickerPresented = false
    movingArticle = nil
    isEditing = true
  }

  public func openArticle(_ article: ArticleItem) {
    if openedTabs.contains(where: { $0.id == article.id }) {
      selectedTabID = article.id
      return
    }

    openedTabs.append(OpenedLinkTab(article: article))
    selectedTabID = article.id
  }

  public func selectTab(_ tabID: String) {
    guard openedTabs.contains(where: { $0.id == tabID }) else { return }
    selectedTabID = tabID
  }

  public func closeTab(_ tabID: String) {
    guard let closingIndex = openedTabs.firstIndex(where: { $0.id == tabID }) else { return }
    openedTabs.remove(at: closingIndex)

    guard selectedTabID == tabID else { return }
    if openedTabs.indices.contains(closingIndex) {
      selectedTabID = openedTabs[closingIndex].id
    } else {
      selectedTabID = openedTabs.last?.id
    }
  }

  public func endEditing() {
    selectedArticleIDs.removeAll()
    isMultiMovePickerPresented = false
    isSingleMovePickerPresented = false
    isDeleteAlertPresented = false
    pendingDeleteArticles.removeAll()
    movingArticle = nil
    isEditing = false
  }

  public func handleCategoryContextChange() {
    endEditing()
    applyFilters()
  }

  public func updateSelection(_ article: ArticleItem, isSelected: Bool) {
    if isSelected {
      selectedArticleIDs.insert(article.id)
    } else {
      selectedArticleIDs.remove(article.id)
    }
  }

  public func toggleSelectAll() {
    let displayedIDs = selectedAllDisplayedArticleIDs()
    if isAllDisplayedArticlesSelected {
      selectedArticleIDs.subtract(displayedIDs)
    } else {
      selectedArticleIDs.formUnion(displayedIDs)
    }
  }

  public func requestDeleteSelectedLinks() {
    let selectedArticles = articles.filter { selectedArticleIDs.contains($0.id) }
    guard !selectedArticles.isEmpty else { return }

    pendingDeleteArticles = selectedArticles
    isDeleteAlertPresented = true
  }

  public func requestDeleteSingleLink(_ article: ArticleItem) {
    pendingDeleteArticles = [article]
    isDeleteAlertPresented = true
  }

  public func deletePendingLinks() {
    let targetArticles = pendingDeleteArticles
    let deletedIDs = Set(targetArticles.map(\.id))
    let deletedCount = targetArticles.count

    guard !targetArticles.isEmpty else {
      clearPendingDelete()
      return
    }

    if !pendingDeletedArticles.isEmpty {
      commitPendingDelete()
    }

    pendingDeletedArticles = targetArticles
    hiddenArticleIDs = Set(pendingDeletedArticles.map(\.id))
    selectedArticleIDs.subtract(deletedIDs)

    if let movingArticle, deletedIDs.contains(movingArticle.id) {
      self.movingArticle = nil
      isSingleMovePickerPresented = false
    }

    deletedIDs.forEach(closeTab)

    if isEditing {
      endEditing()
    }

    applyFilters()
    showDeleteToast(
      deletedCount: deletedCount,
      linkTitle: targetArticles.count == 1 ? targetArticles.first?.title : nil
    )
    clearPendingDelete()
  }

  public func clearPendingDelete() {
    pendingDeleteArticles.removeAll()
    isDeleteAlertPresented = false
  }

  public func presentMultiMovePicker() {
    guard !selectedArticleIDs.isEmpty else { return }
    isMultiMovePickerPresented = true
  }

  public func dismissMultiMovePicker() {
    isMultiMovePickerPresented = false
  }

  public func moveSelectedLinks(to category: CategoryItem?) {
    let targetArticleIDs = selectedArticleIDs
    let targetArticles = articles.filter { targetArticleIDs.contains($0.id) }
    let snapshots = targetArticles.map {
      MovedArticleSnapshot(articleID: $0.id, previousCategory: $0.category)
    }

    targetArticles.forEach { article in
      article.category = category
    }

    saveChanges {
      showMoveToast(
        movedCount: targetArticles.count,
        categoryName: targetArticles.count == 1 ? categoryName(for: category) : nil,
        snapshots: snapshots
      )
      endEditing()
      applyFilters()
    }
  }

  public func presentSingleMovePicker(for article: ArticleItem) {
    movingArticle = article
    isMultiMovePickerPresented = false
    isSingleMovePickerPresented = true
  }

  public func dismissSingleMovePicker() {
    isSingleMovePickerPresented = false
  }

  public func moveSingleLink(to category: CategoryItem?) {
    guard let movingArticle else { return }
    let snapshots = [
      MovedArticleSnapshot(
        articleID: movingArticle.id,
        previousCategory: movingArticle.category
      )
    ]

    movingArticle.category = category

    saveChanges {
      showMoveToast(
        movedCount: 1,
        categoryName: categoryName(for: category),
        snapshots: snapshots
      )
      isSingleMovePickerPresented = false
      self.movingArticle = nil
      applyFilters()
    }
  }

  public func hideMoveToast() {
    moveToastDismissTask?.cancel()
    moveToastDismissTask = nil
    moveToast = nil
  }

  public func undoDelete() {
    pendingDeletedArticles.removeAll()
    hiddenArticleIDs.removeAll()
    applyFilters()
    hideDeleteToast()
  }

  public func commitPendingDelete() {
    let targetArticles = pendingDeletedArticles
    guard !targetArticles.isEmpty else {
      hideDeleteToast()
      return
    }

    targetArticles.forEach { article in
      persistence?.delete(article)
    }

    saveChanges {
      pendingDeletedArticles.removeAll()
      hiddenArticleIDs.removeAll()
      applyFilters()
      hideDeleteToast()
    }
  }

  public func undoMove() {
    guard let moveToast else { return }

    moveToast.snapshots.forEach { snapshot in
      articles
        .first { $0.id == snapshot.articleID }?
        .category = snapshot.previousCategory
    }

    saveChanges {
      hideMoveToast()
      applyFilters()
    }
  }

  public func dismiss() {
    moveToastDismissTask?.cancel()
    commitPendingDelete()
  }
}

private extension LinkListViewModel {
  func applyFilters() {
    syncOpenedTabs()

    let filteredArticles: [ArticleItem]

    if isSeeAllSelected || selectedCategoryID == nil {
      filteredArticles = articles
    } else {
      filteredArticles = articles.filter {
        $0.category?.id == selectedCategoryID
      }
    }

    displayedArticles = filteredArticles
      .filter { !hiddenArticleIDs.contains($0.id) }
      .sorted {
      switch sortOrder {
      case .latest:
        return $0.createAt > $1.createAt
      case .oldest:
        return $0.createAt < $1.createAt
      }
    }

    updateSelectionState()
  }

  func syncOpenedTabs() {
    let articleIDs = Set(articles.map(\.id))
    openedTabs = openedTabs
      .filter { articleIDs.contains($0.id) }
      .map { tab in
        guard let article = articles.first(where: { $0.id == tab.id }) else {
          return tab
        }
        return OpenedLinkTab(article: article)
      }

    if let selectedTabID, !articleIDs.contains(selectedTabID) {
      self.selectedTabID = openedTabs.last?.id
    }
  }

  private func showMoveToast(
    movedCount: Int,
    categoryName: String?,
    snapshots: [MovedArticleSnapshot]
  ) {
    moveToastDismissTask?.cancel()
    moveToast = MoveToastState(
      movedCount: movedCount,
      categoryName: categoryName,
      snapshots: snapshots
    )

    moveToastDismissTask = Task {
      try? await Task.sleep(nanoseconds: 3_000_000_000)
      guard !Task.isCancelled else { return }
      await MainActor.run {
        hideMoveToast()
      }
    }
  }

  func showDeleteToast(
    deletedCount: Int,
    linkTitle: String?
  ) {
    deleteToastDismissTask?.cancel()
    deleteToast = DeleteToastState(
      deletedCount: deletedCount,
      linkTitle: linkTitle
    )

    deleteToastDismissTask = Task {
      try? await Task.sleep(nanoseconds: 3_000_000_000)
      guard !Task.isCancelled else { return }
      await MainActor.run {
        commitPendingDelete()
      }
    }
  }

  func hideDeleteToast() {
    deleteToastDismissTask?.cancel()
    deleteToastDismissTask = nil
    deleteToast = nil
  }

  func categoryName(for category: CategoryItem?) -> String {
    category?.categoryName ?? "전체"
  }

  func saveChanges(onSuccess: () -> Void) {
    do {
      try persistence?.save()
      onSuccess()
    } catch {
      print("update links failed: \(error)")
    }
  }
}
