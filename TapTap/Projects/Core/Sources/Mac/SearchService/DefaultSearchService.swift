//
//  DefaultSearchService.swift
//  Core
//
//  Created by 여성일 on 4/6/26.
//

import Foundation

import Foundation

public final class DefaultSearchService: SearchServicing {
  private let fetchArticles: () -> [ArticleItem]

  public init(fetchArticles: @escaping () -> [ArticleItem]) {
    self.fetchArticles = fetchArticles
  }

  public func search(query: String) -> [ArticleItem] {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return [] }

    return fetchArticles().filter {
      $0.title.localizedCaseInsensitiveContains(trimmed)
    }
  }

  public func relatedKeywords(query: String) -> [String] {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return [] }

    let titles = fetchArticles().map(\.title)

    return Array(
      Set(
        titles.filter { $0.localizedCaseInsensitiveContains(trimmed) }
      )
      .prefix(10)
    )
  }
}
