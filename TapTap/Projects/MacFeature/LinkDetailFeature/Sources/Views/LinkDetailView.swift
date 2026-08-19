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
          categoryIconNumber: viewModel.article.category?.icon.number ?? 1,
          title: viewModel.article.title,
          onOpenOriginalLink: openOriginalLink,
          onOpenMemo: {
            if isMemoPanelPresented {
              closeMemoPanel()
            } else {
              isMemoPanelPresented = true
            }
          },
          onDelete: {
            deleteTarget = .article
          }
        )

        GeometryReader { geometry in
          HStack(spacing: 0) {
            detailContent

            if isMemoPanelPresented {
              memoPanel
                .frame(width: max(360, geometry.size.width * 0.5))
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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

      if let deleteToastMessage = viewModel.deleteToastMessage {
        LinkActionToast(
          variant: .delete,
          message: deleteToastMessage,
          duration: 3,
          onUndoTap: nil,
          onCloseTap: viewModel.hideDeleteToast
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
    .animation(.easeInOut(duration: 0.2), value: viewModel.deleteToastMessage)
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
      onClose: closeMemoPanel
    )
    .frame(maxHeight: .infinity, alignment: .top)
    .shadow(color: Color.black.opacity(0.08), radius: 8, x: -2, y: 0)
  }

  func openOriginalLink() {
    guard let url = URL(string: viewModel.article.urlString) else { return }
    if let safariURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Safari") {
      NSWorkspace.shared.open([url], withApplicationAt: safariURL, configuration: NSWorkspace.OpenConfiguration())
    } else {
      NSWorkspace.shared.open(url)
    }
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
