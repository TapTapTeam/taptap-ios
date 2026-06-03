//
//  HighlightCommentEditorID.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 6/3/26.
//

/// 새 메모 입력 영역으로 스크롤하기 위한 안정적인 View ID를 만듭니다.
enum HighlightCommentEditorID {
  static func newComment(_ highlightID: String) -> String {
    "new-comment-\(highlightID)"
  }
}
