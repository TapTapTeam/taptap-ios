//
//  LinkDetailDeleteTarget.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

/// 삭제 확인 다이얼로그가 처리할 대상과 문구를 정의합니다.
enum LinkDetailDeleteTarget: Equatable {
  case article
  case highlight(String)
  case comment(highlightID: String, commentID: Double)

  var alertTitle: String {
    switch self {
    case .article:
      return "이 링크를 삭제할까요?"
    case .highlight:
      return "해당 하이라이트를 삭제할까요?"
    case .comment:
      return "해당 메모를 삭제할까요?"
    }
  }

  var alertMessage: String {
    switch self {
    case .article:
      return "삭제한 링크는 복구할 수 없어요"
    case .highlight:
      return "메모도 함께 삭제되며, 삭제한 하이라이트는 복구할 수 없어요"
    case .comment:
      return "삭제된 메모는 복구할 수 없어요"
    }
  }
}
