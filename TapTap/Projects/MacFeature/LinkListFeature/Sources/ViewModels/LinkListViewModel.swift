//
//  LinkListViewModel.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import Foundation
import Observation

import Core

struct NavigationHistory: Equatable {
  private(set) var entries: [LinkListViewModel.OpenedLinkTab.Context]
  private(set) var index: Int

  init(initial: LinkListViewModel.OpenedLinkTab.Context) {
    entries = [initial]
    index = 0
  }

  var current: LinkListViewModel.OpenedLinkTab.Context { entries[index] }
  var isBackEnabled: Bool { index > 0 }
  var isForwardEnabled: Bool { index < entries.count - 1 }

  mutating func push(_ context: LinkListViewModel.OpenedLinkTab.Context) {
    guard entries[index] != context else { return }
    if index < entries.count - 1 {
      entries.removeSubrange((index + 1)...)
    }
    entries.append(context)
    index = entries.count - 1
  }

  @discardableResult
  mutating func goBack() -> LinkListViewModel.OpenedLinkTab.Context? {
    guard isBackEnabled else { return nil }
    index -= 1
    return entries[index]
  }

  @discardableResult
  mutating func goForward() -> LinkListViewModel.OpenedLinkTab.Context? {
    guard isForwardEnabled else { return nil }
    index += 1
    return entries[index]
  }
}

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

  public struct ArticleDeleteToastState: Identifiable {
    public let id = UUID()
    public let message: String
  }

  public struct OpenedLinkTab: Identifiable, Equatable {
    public enum Context: Equatable {
      case allLinks
      case category(UUID)
      case article(String)
    }

    public let id: String
    public internal(set) var title: String
    var history: NavigationHistory

    public var context: Context {
      history.current
    }

    public var articleID: String? {
      if case let .article(id) = context {
        return id
      }
      return nil
    }

    static func newTab(title: String) -> OpenedLinkTab {
      OpenedLinkTab(
        id: UUID().uuidString,
        title: title,
        history: NavigationHistory(initial: .allLinks)
      )
    }

    static func articleTab(article: ArticleItem, id: String = UUID().uuidString) -> OpenedLinkTab {
      OpenedLinkTab(
        id: id,
        title: article.title,
        history: NavigationHistory(initial: .article(article.id))
      )
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
  public private(set) var moveToast: MoveToastState?
  public private(set) var deleteToast: DeleteToastState?
  public private(set) var articleDeleteToast: ArticleDeleteToastState?
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
  private var baseHistory = NavigationHistory(initial: .allLinks)
  private var pendingDeleteArticles: [ArticleItem] = []
  private var pendingDeletedArticles: [ArticleItem] = []
  private var persistence: (any LinkListPersistence)?

  @ObservationIgnored private var moveToastDismissTask: Task<Void, Never>?
  @ObservationIgnored private var deleteToastDismissTask: Task<Void, Never>?
  @ObservationIgnored private var articleDeleteToastDismissTask: Task<Void, Never>?

  public init() {}

  deinit {
    moveToastDismissTask?.cancel()
    deleteToastDismissTask?.cancel()
    articleDeleteToastDismissTask?.cancel()
  }

  public func updatePersistence(_ persistence: any LinkListPersistence) {
    self.persistence = persistence
  }

  public func update(
    articles: [ArticleItem],
    categories: [CategoryItem]
  ) {
    self.articles = articles
    self.categories = categories
    self.hiddenArticleIDs = Set(pendingDeletedArticles.map(\.id))
    applyFilters()
  }

  public func selectSortOrder(_ sortOrder: SortOrder) {
    self.sortOrder = sortOrder
  }

  public var categoryTitle: String {
    switch activeContext {
    case .allLinks:
      return "전체"
    case let .category(id):
      return categories.first { $0.id == id }?.categoryName ?? "전체"
    case .article:
      return "전체"
    }
  }

  public var activeContext: OpenedLinkTab.Context {
    if let selectedTabID, let tab = openedTabs.first(where: { $0.id == selectedTabID }) {
      return tab.context
    }
    return baseHistory.current
  }

  public var isBackEnabled: Bool { activeHistorySnapshot.isBackEnabled }
  public var isForwardEnabled: Bool { activeHistorySnapshot.isForwardEnabled }

  public var selectedArticle: ArticleItem? {
    guard
      let selectedTabID,
      let articleID = openedTabs.first(where: { $0.id == selectedTabID })?.articleID
    else { return nil }

    return articles.first { $0.id == articleID }
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

  public func beginNewTabSelection() {
    let tab = OpenedLinkTab.newTab(title: title(for: .allLinks))
    openedTabs.append(tab)
    selectedTabID = tab.id
    endEditing()
    applyFilters()
  }

  public func openArticle(_ article: ArticleItem) {
    // 이미 열려 있는 링크는 새 탭을 만들지 않고 그 탭으로 이동한다.
    // 빈 탭 재사용보다 먼저 확인해야 `+`로 연 빈 탭에 같은 링크가 중복으로 열리지 않는다.
    if let existingTab = openedTabs.first(where: { $0.articleID == article.id }) {
      if let selectedTabID,
         selectedTabID != existingTab.id,
         let selectedIndex = openedTabs.firstIndex(where: { $0.id == selectedTabID }),
         openedTabs[selectedIndex].articleID == nil,
         openedTabs[selectedIndex].history.entries.count == 1 {
        // 링크를 고르려고 방금 연 빈 탭이라면 남겨둘 이유가 없으므로 정리한다.
        openedTabs.remove(at: selectedIndex)
      }

      selectedTabID = existingTab.id
      return
    }

    if let selectedTabID,
       let selectedIndex = openedTabs.firstIndex(where: { $0.id == selectedTabID }),
       openedTabs[selectedIndex].articleID == nil {
      openedTabs[selectedIndex].history.push(.article(article.id))
      openedTabs[selectedIndex].title = article.title
      return
    }

    let tab = OpenedLinkTab.articleTab(article: article)
    openedTabs.append(tab)
    selectedTabID = tab.id
  }

  public func selectTab(_ tabID: String) {
    guard openedTabs.contains(where: { $0.id == tabID }) else { return }
    selectedTabID = tabID
  }

  public func closeTab(_ tabID: String) {
    guard let closingIndex = openedTabs.firstIndex(where: { $0.id == tabID }) else { return }
    openedTabs.remove(at: closingIndex)

    guard selectedTabID == tabID else {
      return
    }

    if openedTabs.indices.contains(closingIndex) {
      selectedTabID = openedTabs[closingIndex].id
    } else {
      selectedTabID = openedTabs.last?.id
    }
  }

  public func closeTabs(articleIDs: Set<String>) {
    let tabIDs = openedTabs
      .filter { tab in
        guard let articleID = tab.articleID else { return false }
        return articleIDs.contains(articleID)
      }
      .map(\.id)

    tabIDs.forEach(closeTab)
  }

  public func endEditing() {
    selectedArticleIDs.removeAll()
    isMultiMovePickerPresented = false
    isSingleMovePickerPresented = false
    pendingDeleteArticles.removeAll()
    movingArticle = nil
    isEditing = false
  }

  public func selectContext(_ context: OpenedLinkTab.Context) {
    if let selectedTabID, let index = openedTabs.firstIndex(where: { $0.id == selectedTabID }) {
      openedTabs[index].history.push(context)
      openedTabs[index].title = title(for: context)
    } else {
      baseHistory.push(context)
    }
    endEditing()
    applyFilters()
  }

  public func goBack() {
    mutateActiveHistory { $0.goBack() }
  }

  public func goForward() {
    mutateActiveHistory { $0.goForward() }
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
    deletePendingLinks()
  }

  public func requestDeleteSingleLink(_ article: ArticleItem) {
    pendingDeleteArticles = [article]
    deletePendingLinks()
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

    closeTabs(articleIDs: deletedIDs)

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

  public func showArticleDeleteToast(title: String) {
    articleDeleteToastDismissTask?.cancel()
    articleDeleteToast = ArticleDeleteToastState(message: "'\(title)'을 삭제했어요")

    articleDeleteToastDismissTask = Task {
      try? await Task.sleep(for: .seconds(3))
      guard !Task.isCancelled else { return }
      await MainActor.run {
        hideArticleDeleteToast()
      }
    }
  }

  public func hideArticleDeleteToast() {
    articleDeleteToastDismissTask?.cancel()
    articleDeleteToastDismissTask = nil
    articleDeleteToast = nil
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
    switch activeContext {
    case .allLinks, .article:
      filteredArticles = articles
    case let .category(id):
      filteredArticles = articles.filter { $0.category?.id == id }
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
      .filter { tab in
        guard let articleID = tab.articleID else { return true }
        return articleIDs.contains(articleID)
      }
      .map { tab in
        var tab = tab
        tab.title = title(for: tab.context)
        return tab
      }

    if let selectedTabID, !openedTabs.contains(where: { $0.id == selectedTabID }) {
      self.selectedTabID = openedTabs.last?.id
    }

  }

  var activeHistorySnapshot: NavigationHistory {
    if let selectedTabID, let tab = openedTabs.first(where: { $0.id == selectedTabID }) {
      return tab.history
    }
    return baseHistory
  }

  func mutateActiveHistory(_ mutate: (inout NavigationHistory) -> OpenedLinkTab.Context?) {
    if let selectedTabID, let index = openedTabs.firstIndex(where: { $0.id == selectedTabID }) {
      guard mutate(&openedTabs[index].history) != nil else { return }
      openedTabs[index].title = title(for: openedTabs[index].context)
    } else {
      guard mutate(&baseHistory) != nil else { return }
    }
    applyFilters()
  }

  func title(for context: OpenedLinkTab.Context) -> String {
    switch context {
    case .allLinks:
      return "모든 링크"
    case let .category(id):
      return categories.first { $0.id == id }?.categoryName ?? "전체"
    case let .article(id):
      return articles.first { $0.id == id }?.title ?? "링크"
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
      try? await Task.sleep(for: .seconds(5))
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
      try? await Task.sleep(for: .seconds(5))
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
