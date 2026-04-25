//
//  DefaultSearchService.swift
//  Core
//
//  Created by 여성일 on 4/6/26.
//

import Foundation

public final class DefaultSearchService: SearchServicing {
  public init() {}
  
  public func search(query: String, in articles: [ArticleItem]) -> [ArticleItem] {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return [] }
    
    return articles.filter {
      $0.title.localizedCaseInsensitiveContains(trimmed)
    }
  }
  
  public func relatedKeywords(query: String, in articles: [ArticleItem]) -> [String] {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return [] }
    
    return Array(
      articles
        .map(\.title)
        .filter { $0.localizedCaseInsensitiveContains(trimmed) }
        .prefix(10)
    )
  }
}
