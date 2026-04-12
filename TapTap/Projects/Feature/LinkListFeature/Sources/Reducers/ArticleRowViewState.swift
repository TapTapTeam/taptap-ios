//
//  ArticleRowViewState.swift
//  LinkListFeature
//
//  Created by Hong on 4/12/26.
//

import Core

struct ArticleRowViewState: Equatable, Identifiable {
  let id: String
  let article: ArticleItem
  
  let title: String
  let category: String
  let imageURL: String
  let dateString: String
  
  init(article: ArticleItem) {
    self.id = article.id
    self.article = article
    
    self.title = article.title
    self.category = article.category?.categoryName ?? "전체"
    self.imageURL = article.imageURL ?? "notImage"
    self.dateString = article.createAt.formattedKoreanDate()
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id &&
    lhs.title == rhs.title &&
    lhs.category == rhs.category &&
    lhs.imageURL == rhs.imageURL &&
    lhs.dateString == rhs.dateString
  }
}
