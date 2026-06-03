//
//  SwiftDataLinkListPersistence.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 6/3/26.
//

import SwiftData

import Core

/// 링크 리스트 화면의 저장/삭제 요청을 실제 저장소에 반영하기 위한 최소 persistence 인터페이스입니다.
@MainActor
public protocol LinkListPersistence {
  func save() throws
  func delete(_ article: ArticleItem)
}

/// LinkListFeature의 링크 저장/삭제 요청을 SwiftData context에 연결합니다.
public struct SwiftDataLinkListPersistence: LinkListPersistence {
  private let modelContext: ModelContext

  public init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }

  public func save() throws {
    try modelContext.save()
  }

  public func delete(_ article: ArticleItem) {
    modelContext.delete(article)
  }
}
