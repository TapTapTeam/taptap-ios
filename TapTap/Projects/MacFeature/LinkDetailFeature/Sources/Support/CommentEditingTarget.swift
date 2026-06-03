//
//  CommentEditingTarget.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

/// 현재 하이라이트 메모 입력이 새 메모 추가인지 기존 메모 수정인지 나타냅니다.
public enum CommentEditingTarget: Equatable {
  case adding(highlightID: String)
  case editing(highlightID: String, commentID: Double)

  var highlightID: String {
    switch self {
    case let .adding(highlightID):
      return highlightID
    case let .editing(highlightID, _):
      return highlightID
    }
  }

  var addingHighlightID: String? {
    guard case let .adding(highlightID) = self else { return nil }
    return highlightID
  }

  func isEditingComment(_ commentID: Double) -> Bool {
    guard case let .editing(_, editingCommentID) = self else { return false }
    return editingCommentID == commentID
  }
}
