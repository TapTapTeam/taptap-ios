//
//  HighlightItemView.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

import SwiftUI

import Core
import DesignSystem

/// 하이라이트 문장과 그 하위 메모 목록, 새 메모 입력 영역을 묶어 보여주는 View입니다.
struct HighlightItemView: View {
  let highlight: HighlightItem
  let kind: HighlightSectionKind
  let commentEditingTarget: CommentEditingTarget?
  @Binding var draftCommentText: String
  @Binding var popupTarget: HighlightPopupTarget?

  let onSelect: (HighlightItem) -> Void
  let onAddComment: (HighlightItem) -> Void
  let onSaveComment: (HighlightItem) -> Void
  let onDeleteHighlight: (String) -> Void
  let onEditComment: (HighlightItem, Comment) -> Void
  let onDeleteComment: (HighlightItem, Comment) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      sentenceButton
      commentList
      newCommentEditor
    }
    .contextMenu {
      Button("메모 추가하기") {
        onAddComment(highlight)
      }

      Button("삭제하기", role: .destructive) {
        onDeleteHighlight(highlight.id)
      }
    }
  }
}

private extension HighlightItemView {
  var sentenceButton: some View {
    Button {
      onSelect(highlight)
      togglePopup(.highlight(highlight.id))
    } label: {
      HighlightSentenceBlock(
        text: highlight.sentence,
        backgroundColor: kind.highlightColor
      )
    }
    .buttonStyle(.plain)
    .anchorPreference(
      key: HighlightPopupAnchorPreferenceKey.self,
      value: .bounds
    ) { anchor in
      [
        .highlight(highlight.id): anchor
      ]
    }
    .zIndex(popupTarget == .highlight(highlight.id) ? 1 : 0)
  }

  @ViewBuilder
  var commentList: some View {
    if highlight.comments.isEmpty {
      HighlightCommentView(
        text: "하이라이트 메모",
        highlight: highlight,
        comment: nil,
        commentEditingTarget: commentEditingTarget,
        draftCommentText: $draftCommentText,
        popupTarget: $popupTarget,
        onAddComment: onAddComment,
        onSaveComment: onSaveComment,
        onEditComment: onEditComment,
        onDeleteComment: onDeleteComment
      )
    } else {
      ForEach(Array(highlight.comments.enumerated()), id: \.element.id) { index, comment in
        HighlightCommentView(
          text: comment.text,
          highlight: highlight,
          comment: comment,
          commentEditingTarget: commentEditingTarget,
          draftCommentText: $draftCommentText,
          popupTarget: $popupTarget,
          onAddComment: onAddComment,
          onSaveComment: onSaveComment,
          onEditComment: onEditComment,
          onDeleteComment: onDeleteComment
        )

        if index < highlight.comments.count - 1 {
          Divider()
            .background(Color.divider1)
            .padding(.top, 16)
            .padding(.bottom, 12)
        }
      }
    }
  }

  @ViewBuilder
  var newCommentEditor: some View {
    if commentEditingTarget?.addingHighlightID == highlight.id {
      InlineCommentEditor(
        text: $draftCommentText,
        onSave: {
          onSaveComment(highlight)
        }
      )
      .padding(.top, 4)
      .id(HighlightCommentEditorID.newComment(highlight.id))
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

/// 하이라이트된 문장 본문을 표시하고 hover 상태를 표현하는 블록입니다.
private struct HighlightSentenceBlock: View {
  let text: String
  let backgroundColor: Color

  @State private var isHovered = false

  var body: some View {
    Text(text)
      .font(.B1_M_HL)
      .foregroundStyle(.text1)
      .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(backgroundColor)
      .overlay {
        if isHovered {
          RoundedRectangle(cornerRadius: 8)
            .fill(Color.bgDimHover)
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .contentShape(RoundedRectangle(cornerRadius: 8))
      .fixedSize(horizontal: false, vertical: true)
      .onHover { hovering in
        isHovered = hovering
      }
      .animation(.easeOut(duration: 0.12), value: isHovered)
  }
}
