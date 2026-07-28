//
//  LinkDetailPersistence.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 6/3/26.
//

import Core

/// 링크 상세 화면의 변경 사항을 실제 저장소에 반영하기 위한 최소 persistence 인터페이스입니다.
@MainActor
public protocol LinkDetailPersistence {
  func save() throws
  func delete(_ article: ArticleItem)
  func delete(_ highlight: HighlightItem)
}
