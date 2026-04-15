//
//  LinkRepository.swift
//  Shared
//
//  Created by 여성일 on 2/12/26.
//

import SwiftData
import Foundation

import Core

public struct LinkRepository {
  private let context: ModelContext
  
  public init(context: ModelContext) {
    self.context = context
  }
  
  // MARK: - Create
  public func addLink(_ link: ArticleItem) throws {
    let urlString = link.urlString
    let descriptor = FetchDescriptor<ArticleItem>(predicate: #Predicate { $0.urlString == urlString })
    
    if let existing = try? context.fetch(descriptor).first {
      existing.title = link.title
      if let newImageURL = link.imageURL {
        existing.imageURL = newImageURL
      }
      existing.lastViewedDate = link.lastViewedDate
    } else {
      context.insert(link)
    }
    try context.save()
  }
  
  // MARK: - Read
  public func fetchLink(id: String) throws -> ArticleItem? {
    try context.fetchOne(
      ArticleItem.self,
      predicate: #Predicate { $0.id == id }
    )
  }
  
  public func fetchLinks(
    predicate: Predicate<ArticleItem>? = nil,
    sortBy: [SortDescriptor<ArticleItem>] = [SortDescriptor(\.createAt, order: .reverse)],
    limit: Int? = nil,
    offset: Int? = nil
  ) throws -> [ArticleItem] {
    var descriptor = FetchDescriptor<ArticleItem>(
      predicate: predicate,
      sortBy: sortBy
    )
    
    if let limit = limit {
      descriptor.fetchLimit = limit
    }
    
    if let offset = offset {
      descriptor.fetchOffset = offset
    }
    
    return try context.fetch(descriptor)
  }

  public func fetchLinksCount(predicate: Predicate<ArticleItem>? = nil) throws -> Int {
    let descriptor = FetchDescriptor<ArticleItem>(predicate: predicate)
    return try context.fetchCount(descriptor)
  }
  
  public func searchLinks(query: String) throws -> [ArticleItem] {
    try context.fetchAll(
      ArticleItem.self,
      predicate: #Predicate { $0.title.contains(query) }
    )
  }
  
  public func fetchRecentLinks(limit: Int = 6) throws -> [ArticleItem] {
    try context.fetchAll(
      ArticleItem.self,
      sortDescriptors: [SortDescriptor(\.lastViewedDate, order: .reverse)],
      fetchLimit: limit
    )
  }
  
  // MARK: - Update
  public func updateLinkLastViewed(_ link: ArticleItem) throws {
    link.lastViewedDate = Date()
    try context.save()
  }
  
  public func updateLinkTitle(
    _ id: String, _
    newTitle: String
  ) throws {
    guard let link = try fetchLink(id: id) else { return }
    link.title = newTitle
    try context.save()
  }
  
  public func updateLinkMemo(
    _ id: String,
    _ memo: String
  ) throws {
    guard let link = try fetchLink(id: id) else { return }
    link.userMemo = memo
    try context.save()
  }

  public func moveLinks(
    _ links: [ArticleItem],
    to category: CategoryItem?
  ) throws {
    links.forEach { $0.category = category }
    try context.save()
  }
  
  // MARK: - Delete
  public func deleteLink(_ link: ArticleItem) throws {
    context.delete(link)
    try context.save()
  }
  
  public func deleteLinks(_ links: [ArticleItem]) throws {
    links.forEach { context.delete($0) }
    try context.save()
  }
  
  public func deleteLinkById(_ id: String) throws {
    guard let link = try fetchLink(id: id) else { return }
    context.delete(link)
    try context.save()
  }
}
