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

  @Published public private(set) var selectedCategory: String = "전체"
  @Published public private(set) var filteredResults: [ArticleItem] = []

  // 검색 결과에 존재하는 카테고리 목록 (드롭다운에 사용)
  public var categoryItems: [String] {
    let cats = searchResults.compactMap { $0.category?.categoryName }
    return ["전체"] + cats.sorted()
  }

  public func selectCategory(_ category: String) {
    selectedCategory = category
    applyFilter()
  }
  
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

  // SwiftData 아티클 업데이트 메소드
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

  // 검색창 포커스 시 최근 검색어 표시 메소드
  public func focus() {
    showRecentOrEmpty()
  }

  // 검색창 텍스트 변경 시 연관 키워드 업데이트 메소드
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

  // 검색 실행 메소드
  public func submitQuery() {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }

    recentService.add(trimmed)
    performSearch()
    hasSubmittedSearch = true
  }

  // 최근 검색어 선택 메소드
  public func selectRecentKeyword(_ keyword: String) {
    query = keyword
    performSearch()
    hasSubmittedSearch = true
  }

  // 연관 검색어 선택 메소드
  public func selectRelatedKeyword(_ keyword: String) {
    query = keyword
    recentService.add(keyword)
    performSearch()
    hasSubmittedSearch = true
  }

  // 최근 검색어 삭제 메소드
  public func removeRecent(_ keyword: String) {
    recentService.remove(keyword)
    showRecentOrEmpty()
  }

  // 최근 검색어 일괄 삭제 메소드
  public func clearRecent() {
    recentService.clear()
    showRecentOrEmpty()
  }

  // 검색 초기화 메소드
  public func clearSearch() {
    query = ""
    searchResults = []
    filteredResults = []      
    selectedCategory = "전체"
    isSearching = false
    hasSubmittedSearch = false
    showRecentOrEmpty()
  }
}

// MARK: - Private
private extension SearchViewModel {
  // 최근 검색어 존재 여부에 따라 상태 업데이트 메소드
  private func showRecentOrEmpty() {
    let recent = recentService.fetch()
    state = recent.isEmpty ? .empty : .recent(recent)
  }

  // 검색 실행 및 결과 저장 메소드
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
    selectedCategory = "전체"
    applyFilter()
    isSearching = false
  }

  // 입력 중 연관 키워드 탐색 메소드
  private func performRelatedSearch() {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

    guard !trimmed.isEmpty else {
      showRecentOrEmpty()
      return
    }

    let related = searchService.relatedKeywords(query: trimmed, in: articles)
    state = related.isEmpty ? .empty : .related(related)
  }
  
  // 필터링 적용 메소드
  private func applyFilter() {
    guard selectedCategory != "전체" else {
      filteredResults = searchResults
      return
    }
    
    filteredResults = searchResults.filter {
      $0.category?.categoryName == selectedCategory
    }
  }
}
