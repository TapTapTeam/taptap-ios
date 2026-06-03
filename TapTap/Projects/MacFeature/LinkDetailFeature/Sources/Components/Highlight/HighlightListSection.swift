//
//  HighlightListSection.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/11/26.
//

import SwiftUI

import Core
import DesignSystem

/// 하이라이트 전체 목록을 타입별 섹션으로 나누고 팝업 위치를 관리하는 View입니다.
struct HighlightListSection: View {
  let highlights: [HighlightItem]
  let commentEditingTarget: CommentEditingTarget?
  @Binding var draftCommentText: String

  let onSelect: (HighlightItem) -> Void
  let onAddComment: (HighlightItem) -> Void
  let onSaveComment: (HighlightItem) -> Void
  let onDeleteHighlight: (String) -> Void
  let onEditComment: (HighlightItem, Comment) -> Void
  let onDeleteComment: (HighlightItem, Comment) -> Void

  @State private var popupTarget: HighlightPopupTarget?

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      if highlights.isEmpty {
        emptyStateView
      } else {
        highlightListView
      }
    }
    .overlayPreferenceValue(HighlightPopupAnchorPreferenceKey.self) { preferences in
      GeometryReader { proxy in
        if let popupTarget,
           let anchor = preferences[popupTarget] {
          let rect = proxy[anchor]
          popup(for: popupTarget)
            .position(
              x: rect.maxX - HighlightPopupLayout.width / 2,
              y: rect.maxY + HighlightPopupLayout.height / 2 + 6
            )
            .zIndex(100)
        }
      }
      .allowsHitTesting(true)
    }
  }
}

private extension HighlightListSection {
  var emptyStateView: some View {
    VStack(alignment: .center, spacing: 26) {
      DesignSystemAsset.edit.swiftUIImage
        .renderingMode(.template)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(.bl6)
        .frame(width: 32, height: 32)

      Text("나의 요약본이 존재하지 않아요!")
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .frame(maxWidth: .infinity)

      Text("원문을 읽고 중요한 부분에\n하이라이트와 메모를 남겨보세요")
        .font(.B3_R_HLM)
        .foregroundStyle(.text1)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
    .padding(.top, 40)
  }

  var highlightListView: some View {
    VStack(spacing: 22) {
      ForEach(HighlightSectionKind.allCases) { kind in
        let items = highlights.filter {
          HighlightSectionKind.fromType($0.type) == kind
        }

        if !items.isEmpty {
          HighlightSectionView(
            kind: kind,
            highlights: items,
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
  }

  @ViewBuilder
  func popup(for target: HighlightPopupTarget) -> some View {
    switch target {
    case let .highlight(highlightID):
      if let highlight = highlights.first(where: { $0.id == highlightID }) {
        MacPopup(
          normalImage: Image(systemName: "text.badge.plus"),
          normalTitle: "메모 추가하기",
          dangerImage: Image(systemName: "trash"),
          dangerTitle: "삭제하기",
          onNormalTap: {
            popupTarget = nil
            onAddComment(highlight)
          },
          onDangerTap: {
            popupTarget = nil
            onDeleteHighlight(highlightID)
          }
        )
      }

    case let .comment(highlightID, commentID):
      if let highlight = highlights.first(where: { $0.id == highlightID }),
         let comment = highlight.comments.first(where: { $0.id == commentID }) {
        MacPopup(
          normalImage: Image(systemName: "pencil"),
          normalTitle: "수정하기",
          dangerImage: Image(systemName: "trash"),
          dangerTitle: "삭제하기",
          onNormalTap: {
            popupTarget = nil
            onEditComment(highlight, comment)
          },
          onDangerTap: {
            popupTarget = nil
            onDeleteComment(highlight, comment)
          }
        )
      }
    }
  }
}
