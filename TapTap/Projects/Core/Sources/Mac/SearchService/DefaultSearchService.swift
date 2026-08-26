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
    
    // 같은 제목의 링크가 여럿이면 연관 검색어가 똑같은 줄로 반복되므로 중복을 걷어낸다.
    var seen: Set<String> = []
    var keywords: [String] = []

    for title in articles.lazy.map(\.title)
    where title.localizedCaseInsensitiveContains(trimmed) {
      guard seen.insert(title.lowercased()).inserted else { continue }
      keywords.append(title)
      if keywords.count == 10 { break }
    }

    return keywords
  }
}
