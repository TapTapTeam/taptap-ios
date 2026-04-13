//
//  SearchViewModel.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import Core

@MainActor
public final class SearchViewModel: ObservableObject {
  public enum State {
    case empty
    case recent([String])
    case related([String])
  }

  @Published public var query: String = ""
  @Published public private(set) var state: State = .empty
  @Published public private(set) var searchResults: [ArticleItem] = []
  @Published public private(set) var isSearching: Bool = false
  @Published public private(set) var hasSubmittedSearch: Bool = false

  private let searchService: SearchServicing
  private let recentService: RecentSearchServicing
  private var articles: [ArticleItem] = []

  public init(
    searchService: SearchServicing,
    recentService: RecentSearchServicing
  ) {
    self.searchService = searchService
    self.recentService = recentService
  }

  public func updateArticles(_ articles: [ArticleItem]) {
    self.articles = articles

    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

    guard !trimmed.isEmpty else { return }

    if hasSubmittedSearch {
      performSearch()
    } else {
      performRelatedSearch()
    }
  }

  public func focus() {
    showRecentOrEmpty()
  }

  public func updateQuery(_ newValue: String) {
    query = newValue

    let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)

    if trimmed.isEmpty {
      hasSubmittedSearch = false
      searchResults = []
      showRecentOrEmpty()
    } else {
      performRelatedSearch()
    }
  }

  public func submitQuery() {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }

    recentService.add(trimmed)
    performSearch()
    hasSubmittedSearch = true
  }

  public func selectRecentKeyword(_ keyword: String) {
    query = keyword
    performSearch()
    hasSubmittedSearch = true
  }

  public func selectRelatedKeyword(_ keyword: String) {
    query = keyword
    recentService.add(keyword)
    performSearch()
    hasSubmittedSearch = true
  }

  public func removeRecent(_ keyword: String) {
    recentService.remove(keyword)
    showRecentOrEmpty()
  }

  public func clearRecent() {
    recentService.clear()
    showRecentOrEmpty()
  }

  public func clearSearch() {
    query = ""
    searchResults = []
    isSearching = false
    hasSubmittedSearch = false
    showRecentOrEmpty()
  }

  private func showRecentOrEmpty() {
    let recent = recentService.fetch()
    state = recent.isEmpty ? .empty : .recent(recent)
  }

  private func performSearch() {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

    guard !trimmed.isEmpty else {
      searchResults = []
      isSearching = false
      hasSubmittedSearch = false
      return
    }

    isSearching = true
    searchResults = searchService.search(query: trimmed, in: articles)
    isSearching = false
  }

  private func performRelatedSearch() {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

    guard !trimmed.isEmpty else {
      showRecentOrEmpty()
      return
    }

    let related = searchService.relatedKeywords(query: trimmed, in: articles)
    state = related.isEmpty ? .empty : .related(related)
  }
}
