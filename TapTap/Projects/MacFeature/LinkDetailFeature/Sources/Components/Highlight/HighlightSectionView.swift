//
//  HighlightSectionView.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

import SwiftUI

import Core

/// 같은 타입의 하이라이트들을 하나의 섹션으로 렌더링합니다.
struct HighlightSectionView: View {
  let kind: HighlightSectionKind
  let highlights: [HighlightItem]
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
    VStack(alignment: .leading, spacing: 14) {
      header

      VStack(spacing: 12) {
        ForEach(highlights) { highlight in
          HighlightItemView(
            highlight: highlight,
            kind: kind,
            commentEditingTarget: commentEditingTarget,
            draftCommentText: $draftCommentText,
            popupTarget: $popupTarget,
            onSelect: onSelect,
            onAddComment: onAddComment,
            onSaveComment: onSaveComment,
            onDeleteHighlight: onDeleteHighlight,
            onEditComment: onEditComment,
            onDeleteComment: onDeleteComment
          )
        }
      }
    }
    .padding(.bottom, 18)
    .overlay(alignment: .bottom) {
      Divider()
    }
  }
}

private extension HighlightSectionView {
  var header: some View {
    HStack(spacing: 8) {
      RoundedRectangle(cornerRadius: 4)
        .fill(kind.swatchColor)
        .frame(width: 22, height: 22)

      Text(kind.title)
        .font(.B1_M)
        .foregroundStyle(kind.textColor)
    }
  }
}
