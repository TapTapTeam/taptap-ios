//
//  HighlightCommentView.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

import SwiftUI

import Core
import DesignSystem

/// 하이라이트 메모의 표시, 편집 진입, 컨텍스트 메뉴를 담당하는 행 View입니다.
struct HighlightCommentView: View {
  let text: String
  let highlight: HighlightItem
  let comment: Comment?
  let commentEditingTarget: CommentEditingTarget?
  @Binding var draftCommentText: String
  @Binding var popupTarget: HighlightPopupTarget?

  let onAddComment: (HighlightItem) -> Void
  let onSaveComment: (HighlightItem) -> Void
  let onEditComment: (HighlightItem, Comment) -> Void
  let onDeleteComment: (HighlightItem, Comment) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if let comment, commentEditingTarget?.isEditingComment(comment.id) == true {
        InlineCommentEditor(
          text: $draftCommentText,
          onSave: {
            onSaveComment(highlight)
          }
        )
      } else {
        commentButton
      }
    }
  }
}

private extension HighlightCommentView {
  var commentButton: some View {
    Button {
      if let comment {
        togglePopup(.comment(highlightID: highlight.id, commentID: comment.id))
      } else {
        onAddComment(highlight)
      }
    } label: {
      HighlightCommentBlock(
        text: text,
        isPlaceholder: comment == nil
      )
    }
    .buttonStyle(.plain)
    .anchorPreference(
      key: HighlightPopupAnchorPreferenceKey.self,
      value: .bounds
    ) { anchor in
      guard let comment else { return [:] }
      return [
        .comment(highlightID: highlight.id, commentID: comment.id): anchor
      ]
    }
    .zIndex(
      comment.map {
        popupTarget == .comment(highlightID: highlight.id, commentID: $0.id)
      } ?? false ? 1 : 0
    )
    .contextMenu {
      if let comment {
        Button("수정하기") {
          onEditComment(highlight, comment)
        }

        Button("삭제하기", role: .destructive) {
          onDeleteComment(highlight, comment)
        }
      } else {
        Button("메모 추가하기") {
          onAddComment(highlight)
        }
      }
    }
  }

  func togglePopup(_ target: HighlightPopupTarget) {
    if popupTarget == target {
      popupTarget = nil
    } else {
      popupTarget = target
    }
  }
}

/// 하이라이트 메모 텍스트와 placeholder를 같은 스타일로 보여주는 블록입니다.
private struct HighlightCommentBlock: View {
  let text: String
  let isPlaceholder: Bool

  @State private var isHovered = false

  var body: some View {
    Text(text)
      .font(.B1_M_HL)
      .foregroundStyle(isPlaceholder ? Color.caption2 : Color.text1)
      .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(Color.n20)
      .overlay {
        if isHovered {
          RoundedRectangle(cornerRadius: 6)
            .fill(Color.bgDimHover)
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .contentShape(RoundedRectangle(cornerRadius: 6))
      .onHover { hovering in
        isHovered = hovering
      }
      .animation(.easeOut(duration: 0.12), value: isHovered)
  }
}
