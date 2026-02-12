//
//  CategoryRepository.swift
//  Shared
//
//  Created by 여성일 on 2/12/26.
//

import SwiftData
import Foundation

import Core

public struct CategoryRepository {
  private let context: ModelContext
  
  public init(context: ModelContext) {
    self.context = context
  }
  
  // MARK: - Create
  public func addCategory(_ category: CategoryItem) throws {
    context.insert(category)
    try context.save()
  }
  
  // MARK: - Read
  public func fetchCategories() throws -> [CategoryItem] {
    try context.fetchAll(CategoryItem.self)
  }
  
  // MARK: - Update
  public func updateCategory(_ category: CategoryItem) throws {
    try context.save()
  }
  
  public func updateCategoryItem(id: UUID, name: String, icon: CategoryIcon) throws {
      if let category = try context.fetchOne(
        CategoryItem.self,
        predicate: #Predicate { $0.id == id }) {
          category.categoryName = name
          category.icon = icon
          try context.save()
      }
  }
  
  // MARK: - Delete
  public func deleteCategory(_ category: CategoryItem) throws {
    context.delete(category)
    try context.save()
  }
}
