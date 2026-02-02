//
//  OriginalArticlePayload.swift
//  Feature
//
//  Created by 여성일 on 11/6/25.
//

import Foundation

public struct OriginalPayload: Codable {
  public let articleItem: ArticleItem
  
  public init(
    articleItem: ArticleItem
  ) {
    self.articleItem = articleItem
  }
}
