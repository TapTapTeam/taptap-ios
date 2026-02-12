//
//  ModelContext.Extension.swift
//  Shared
//
//  Created by 여성일 on 2/12/26.
//

import SwiftData
import Foundation

extension ModelContext {
  /// 지정한 PersistentModel 타입에서 선택적으로 필터, 정렬, 갯수 제한을 적용하여 객체를 가져옵니다.
  ///
  /// - Parameters:
  ///   - type: 가져올 PersistentModel 타입
  ///   - predicate: 필터 조건 (`Predicate`). 기본값: `nil` (조건 없음)
  ///   - sortDescriptors: 정렬 조건 (`[SortDescriptor]`). 기본값: `nil` (정렬 없음)
  ///   - fetchLimit: 가져올 최대 개수 (`Int`). 기본값: `nil` (제한 없음)
  /// - Returns: 조건에 맞는 객체 배열을 반환합니다.
  /// - Throws: fetch 동작 중 오류가 발생하면 예외를 던집니다.
  /// **Example**
  /// ```swift
  /// // 전체 fetch
  /// let articles = try context.fetchAll(ArticleItem.self)
  ///
  /// // predicate
  /// let swiftArticles = try context.fetchAll(
  ///     ArticleItem.self,
  ///     predicate: #Predicate { $0.title.contains("Swift") }
  /// )
  ///
  /// // 정렬 + fetchLimit
  /// let recentArticles = try context.fetchAll(
  ///     ArticleItem.self,
  ///     sortDescriptors: [SortDescriptor(\.lastViewedDate, order: .reverse)],
  ///     fetchLimit: 5
  /// )
  /// ```
  func fetchAll<T: PersistentModel>(
      _ type: T.Type,
      predicate: Predicate<T>? = nil,
      sortDescriptors: [SortDescriptor<T>]? = nil,
      fetchLimit: Int? = nil
  ) throws -> [T] {
      var descriptor = FetchDescriptor<T>()

      if let predicate = predicate {
          descriptor.predicate = predicate
      }
      if let sortDescriptors = sortDescriptors {
          descriptor.sortBy = sortDescriptors
      }
      if let fetchLimit = fetchLimit {
          descriptor.fetchLimit = fetchLimit
      }

      return try fetch(descriptor)
  }
  
  /// 지정한 PersistentModel 타입에서 주어진 조건(predicate)에 맞는 단일 객체를 가져옵니다.
  ///
  /// - Parameters:
  ///   - type: 가져올 PersistentModel 타입
  ///   - predicate: 조건을 나타내는 `Predicate`
  /// - Returns: 조건에 맞는 첫 번째 객체를 반환하며, 없으면 `nil`을 반환합니다.
  /// - Throws: fetch 동작 중 오류가 발생하면 예외를 던집니다.
  ///
  /// **Example**
  /// ```swift
  /// let article: ArticleItem? = try context.fetchOne(ArticleItem.self, predicate: #Predicate { $0.id == "123" })
  /// ```
  func fetchOne<T: PersistentModel>(
    _ type: T.Type,
    predicate: Predicate<T>
  ) throws -> T? {
    let descriptor = FetchDescriptor<T>(predicate: predicate)
    return try fetch(descriptor).first
  }
}
