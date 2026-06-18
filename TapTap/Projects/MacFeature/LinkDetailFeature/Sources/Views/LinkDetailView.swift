//
//  LinkDetailView.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/11/26.
//

import SwiftUI
import AppKit

import Core
import DesignSystem

/// 선택된 링크의 상세, 메모, 하이라이트 편집 화면입니다.
public struct LinkDetailView: View {
  @Bindable private var viewModel: LinkDetailViewModel
  @State private var isMemoPanelPresented: Bool = false
  @State private var deleteTarget: LinkDetailDeleteTarget?

  public init(viewModel: LinkDetailViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
    ZStack(alignment: .top) {
      VStack(spacing: 0) {
        LinkDetailToolbar(
          categoryName: viewModel.article.category?.categoryName ?? "전체",
          title: viewModel.article.title,
          onOpenOriginalLink: openOriginalLink,
          onOpenMemo: {
            isMemoPanelPresented = true
          },
          onDelete: {
            deleteTarget = .article
          }
        )

        HStack(spacing: 0) {
          detailContent

          if isMemoPanelPresented {
            memoPanel
              .transition(.move(edge: .trailing).combined(with: .opacity))
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }

      if let toastMessage = viewModel.toastMessage {
        LinkDetailToastView(
          message: toastMessage,
          onClose: viewModel.hideToast
        )
        .padding(.horizontal, 30)
        .padding(.top, 32)
        .zIndex(20)
      }

      if let deleteTarget {
        MacAlertDialog(
          title: deleteTarget.alertTitle,
          message: deleteTarget.alertMessage,
          onCancel: {
            self.deleteTarget = nil
          },
          onDestructive: {
            confirmDelete(deleteTarget)
          }
        )
        .zIndex(30)
      }
    }
    .background(Color.background)
    .onDisappear {
      if !viewModel.isDeleted {
        viewModel.saveMemoIfNeeded()
      }
    }
    .animation(.easeInOut(duration: 0.2), value: viewModel.toastMessage)
    .animation(.easeInOut(duration: 0.2), value: isMemoPanelPresented)
  }
}

private extension LinkDetailView {
  var detailContent: some View {
    ScrollViewReader { proxy in
      ScrollView {
        VStack(alignment: .leading, spacing: 22) {
          if !viewModel.highlights.isEmpty {
            LinkDetailHeaderView(
              date: viewModel.article.createAt,
              title: viewModel.article.title
            )
          }

          HighlightListSection(
            highlights: viewModel.highlights,
            commentEditingTarget: viewModel.commentEditingTarget,
            draftCommentText: $viewModel.draftCommentText,
            onOpenOriginalLink: openOriginalLink,
            onSelect: viewModel.selectHighlight,
            onAddComment: { highlight in
              viewModel.beginCommentAdding(to: highlight)
            },
            onSaveComment: viewModel.saveCommentEditing,
            onDeleteHighlight: { highlightID in
              deleteTarget = .highlight(highlightID)
            },
            onEditComment: viewModel.beginCommentEditing,
            onDeleteComment: { highlight, comment in
              deleteTarget = .comment(
                highlightID: highlight.id,
                commentID: comment.id
              )
            }
          )
        }
        .frame(maxWidth: 600)
        .frame(
          maxWidth: .infinity,
          alignment: isMemoPanelPresented ? .leading : .center
        )
        .padding(.top, 18)
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
      }
      .onChange(of: viewModel.commentEditingTarget) { _, target in
        guard let highlightID = target?.addingHighlightID else { return }

        withAnimation(.easeInOut(duration: 0.2)) {
          proxy.scrollTo(HighlightCommentEditorID.newComment(highlightID), anchor: .center)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  var memoPanel: some View {
    LinkMemoEditor(
      text: $viewModel.editedMemo,
      onSave: {
        viewModel.saveMemoIfNeeded()
      },
      onClose: closeMemoPanel
    )
    .frame(width: 360)
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(16)
    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 0)
  }

  func openOriginalLink() {
    guard let url = URL(string: viewModel.article.urlString) else { return }
    NSWorkspace.shared.open(url)
  }

  func closeMemoPanel() {
    viewModel.saveMemoIfNeeded()
    isMemoPanelPresented = false
  }

  func confirmDelete(_ target: LinkDetailDeleteTarget) {
    deleteTarget = nil

    switch target {
    case .article:
      viewModel.deleteArticle()
    case let .highlight(highlightID):
      viewModel.deleteHighlight(highlightID)
    case let .comment(highlightID, commentID):
      guard
        let highlight = viewModel.highlights.first(where: { $0.id == highlightID }),
        let comment = highlight.comments.first(where: { $0.id == commentID })
      else { return }

      viewModel.deleteComment(comment, from: highlight)
    }
  }
}
