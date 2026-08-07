//
//  Category.swift
//  Domain
//
//  Created by 여성일 on 10/17/25.
//

import Foundation
import SwiftData

public struct CategoryIcon: Codable, Hashable {
  public let number: Int
  
  public init(number: Int = 1) {
    self.number = number
  }
  
  public var name: String {
    "primaryCategoryIcon\(self.number)"
  }
}

public struct CategoryCommand {
  private let context: ModelContext
  
  public init(context: ModelContext) {
    self.context = context
  }
  
  public func toggleFavorite(id: UUID) throws {
    guard let category = try fetchCategory(id: id) else { return }
    category.isFavorite.toggle()
    try context.save()
  }

  public func setFavorite(id: UUID, isFavorite: Bool) throws {
    guard let category = try fetchCategory(id: id) else { return }
    category.isFavorite = isFavorite
    try context.save()
  }
  
  public func updateCategory(id: UUID, name: String, icon: CategoryIcon) throws {
    guard let category = try fetchCategory(id: id) else { return }
    category.categoryName = name
    category.icon = icon
    try context.save()
  }

  public func deleteCategory(id: UUID) throws {
    guard let category = try fetchCategory(id: id) else { return }
    category.links?.forEach { article in
      article.category = nil
    }
    context.delete(category)
    try context.save()
  }
  
  private func fetchCategory(id: UUID) throws -> CategoryItem? {
    let descriptor = FetchDescriptor<CategoryItem>(
      predicate: #Predicate { $0.id == id }
    )
    
    return try context.fetch(descriptor).first
  }
}

// CategoryItem은 TapTapSchema.swift에서 VersionedSchema로 정의되어 있습니다.
