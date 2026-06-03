//
//  SwiftDataLinkDetailPersistence.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 6/3/26.
//

import SwiftData

import Core
import MacLinkDetailFeature

/// 링크 상세 화면의 저장/삭제 요청을 LinkListFeature의 SwiftData context에 연결합니다.
struct SwiftDataLinkDetailPersistence: LinkDetailPersistence {
  private let modelContext: ModelContext

  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }

  func save() throws {
    try modelContext.save()
  }

  func delete(_ highlight: HighlightItem) {
    modelContext.delete(highlight)
  }

  func delete(_ article: ArticleItem) {
    modelContext.delete(article)
  }
}
