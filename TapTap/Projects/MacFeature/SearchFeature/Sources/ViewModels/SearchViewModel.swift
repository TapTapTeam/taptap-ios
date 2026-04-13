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
  
  private let searchService: SearchServicing
  private let recentService: RecentSearchServicing
  
  public init(
    searchService: SearchServicing,
    recentService: RecentSearchServicing
  ) {
    self.searchService = searchService
    self.recentService = recentService
  }
  
  public func focus() {
    showRecentOrEmpty()
  }
  
  public func updateQuery(_ newValue: String) {
    query = newValue
    
    let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if trimmed.isEmpty {
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
  }
  
  public func selectRecentKeyword(_ keyword: String) {
    query = keyword
    performSearch()
  }
  
  public func selectRelatedKeyword(_ keyword: String) {
    query = keyword
    recentService.add(keyword)
    performSearch()
  }
  
  public func removeRecent(_ keyword: String) {
    recentService.remove(keyword)
    showRecentOrEmpty()
  }
  
  public func clearRecent() {
    recentService.clear()
    showRecentOrEmpty()
  }
  
  private func showRecentOrEmpty() {
    let recent = recentService.fetch()
    
    if recent.isEmpty {
      state = .empty
    } else {
      state = .recent(recent)
    }
  }
  
  private func performSearch() {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard !trimmed.isEmpty else {
      searchResults = []
      isSearching = false
      return
    }
    
    isSearching = true
    searchResults = searchService.search(query: trimmed)
    isSearching = false
  }
  
  private func performRelatedSearch() {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard !trimmed.isEmpty else {
      showRecentOrEmpty()
      return
    }
    
    let related = searchService.relatedKeywords(query: trimmed)
    
    if related.isEmpty {
      state = .empty
    } else {
      state = .related(related)
    }
  }
}
