//
//  HighlightRepository.swift
//  Shared
//
//  Created by 여성일 on 2/12/26.
//

import Foundation
import SwiftData

import Core

public struct HighlightRepository {
  private let context: ModelContext
  
  public init(context: ModelContext) {
    self.context = context
  }
  
  // MARK: - Create
  public func addComment(
    _ comment: Comment,
    to highlightId: String
  ) throws {
    guard let highlight = try context.fetchOne(
      HighlightItem.self,
      predicate: #Predicate { $0.id == highlightId }
    ) else { return }
    
    highlight.comments.append(comment)
    try context.save()
  }
  
  // MARK: - Update
  public func updateHighlightsForLink(
    linkID: String,
    highlights: [HighlightItem]
  ) throws {
      if let article = try context.fetchOne(
        ArticleItem.self,
        predicate: #Predicate { $0.id == linkID }
      ) {
          article.highlights.forEach { context.delete($0) }
          article.highlights = highlights
          try context.save()
      }
  }
  
  public func updateComment(
    commentId: Double,
    newText: String,
    highlightId: String) throws {
      guard let highlight = try context.fetchOne(
        HighlightItem.self,
        predicate: #Predicate { $0.id == highlightId }
      ) else { return }
      
      guard let index = highlight.comments.firstIndex(where: { $0.id == commentId }) else { return }
      let old = highlight.comments[index]
      highlight.comments[index] = Comment(id: old.id, type: old.type, text: newText)
      try context.save()
  }
  
  // MARK: - Delete
  public func deleteComment(
    commentId: Double,
    highlightId: String
  ) throws {
      guard let highlight = try context.fetchOne(
        HighlightItem.self,
        predicate: #Predicate { $0.id == highlightId }
      ) else { return }
    
      highlight.comments.removeAll { $0.id == commentId }
      try context.save()
  }
  
  public func deleteHighlight(_ id: String) throws {
      if let highlight = try context.fetchOne(
        HighlightItem.self,
        predicate: #Predicate { $0.id == id }
      ) {
          context.delete(highlight)
          try context.save()
      }
  }
}
