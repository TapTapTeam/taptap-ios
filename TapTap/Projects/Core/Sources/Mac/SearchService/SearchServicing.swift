//
//  SearchServicing.swift
//  Core
//
//  Created by 여성일 on 4/6/26.
//

import Foundation

public protocol SearchServicing {
  func search(query: String, in articles: [ArticleItem]) -> [ArticleItem]
  func relatedKeywords(query: String, in articles: [ArticleItem]) -> [String]
}
