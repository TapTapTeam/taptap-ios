//
//  LinkDetailViewModel.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/11/26.
//

import Foundation
import Observation

import Core

/// 링크 상세 화면의 메모, 하이라이트, 하이라이트 메모 편집 상태를 관리합니다.
@MainActor
@Observable
public final class LinkDetailViewModel {
  public private(set) var article: ArticleItem
  public var editedMemo: String
  public var selectedHighlightID: String?
  public var commentEditingTarget: CommentEditingTarget?
  public var draftCommentType: String = ""
  public var draftCommentText: String = ""
  public private(set) var isDeleted: Bool = false
  public private(set) var toastMessage: String?
  public private(set) var deleteToastMessage: String?

  @ObservationIgnored private var persistence: (any LinkDetailPersistence)?
  @ObservationIgnored private var toastDismissTask: Task<Void, Never>?
  @ObservationIgnored private var deleteToastDismissTask: Task<Void, Never>?

  public init(
    article: ArticleItem,
    persistence: (any LinkDetailPersistence)? = nil
  ) {
    self.article = article
    self.editedMemo = article.userMemo
    self.persistence = persistence
  }

  deinit {
    toastDismissTask?.cancel()
    deleteToastDismissTask?.cancel()
  }

  public var highlights: [HighlightItem] {
    (article.highlights ?? [])
      .sorted { $0.createdAt > $1.createdAt }
  }

  public func updatePersistence(_ persistence: any LinkDetailPersistence) {
    self.persistence = persistence
  }

  public func updateArticle(_ article: ArticleItem) {
    guard self.article.id != article.id else {
      self.article = article
      return
    }

    self.article = article
    editedMemo = article.userMemo
    selectedHighlightID = nil
    cancelCommentEditing()
  }

  public func saveMemoIfNeeded(showsToast: Bool = false) {
    guard !isDeleted else { return }

    let nextMemo = editedMemo.trimmingCharacters(in: .whitespacesAndNewlines)
    guard nextMemo != article.userMemo else { return }

    article.userMemo = nextMemo
    saveChanges {
      if showsToast {
        showToast("메모를 저장했어요")
      }
    }
  }

  public func deleteArticle() {
    guard !isDeleted else { return }
    guard let persistence else {
      showToast("삭제하지 못했어요")
      return
    }

    do {
      persistence.delete(article)
      try persistence.save()
      isDeleted = true
    } catch {
      showToast("삭제하지 못했어요")
      print("delete link failed: \(error)")
    }
  }

  public func selectHighlight(_ highlight: HighlightItem) {
    selectedHighlightID = highlight.id
  }

  public func cancelCommentEditing() {
    commentEditingTarget = nil
    draftCommentType = ""
    draftCommentText = ""
  }

  public func beginCommentAdding(to highlight: HighlightItem) {
    selectedHighlightID = highlight.id
    commentEditingTarget = .adding(highlightID: highlight.id)
    draftCommentType = highlight.type
    draftCommentText = ""
  }

  public func beginCommentEditing(
    highlight: HighlightItem,
    comment: Comment?
  ) {
    selectedHighlightID = highlight.id
    commentEditingTarget = comment.map {
      .editing(highlightID: highlight.id, commentID: $0.id)
    }
    draftCommentType = comment?.type ?? highlight.type
    draftCommentText = comment?.text ?? ""
  }

  public func saveCommentEditing(for highlight: HighlightItem) {
    let nextText = draftCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
    let nextType = draftCommentType.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !nextText.isEmpty else {
      cancelCommentEditing()
      return
    }

    if case let .editing(_, editingCommentID) = commentEditingTarget {
      highlight.comments = highlight.comments.map { comment in
        guard comment.id == editingCommentID else { return comment }
        return Comment(id: comment.id, type: nextType, text: nextText)
      }
    } else {
      var comments = highlight.comments
      comments.append(
        Comment(
          id: Date().timeIntervalSince1970,
          type: nextType,
          text: nextText
        )
      )
      highlight.comments = comments
    }

    commentEditingTarget = nil
    draftCommentType = ""
    draftCommentText = ""
    saveChanges()
  }

  public func deleteComment(
    _ comment: Comment,
    from highlight: HighlightItem
  ) {
    highlight.comments = highlight.comments.filter { $0.id != comment.id }
    if commentEditingTarget?.isEditingComment(comment.id) == true {
      commentEditingTarget = nil
      draftCommentText = ""
    }
    saveChanges {
      showDeleteToast("메모를 삭제했어요")
    }
  }

  public func deleteHighlight(_ highlightID: String) {
    guard let highlight = highlights.first(where: { $0.id == highlightID }) else { return }

    if selectedHighlightID == highlightID {
      selectedHighlightID = nil
    }

    article.highlights?.removeAll { $0.id == highlightID }
    persistence?.delete(highlight)
    saveChanges {
      showDeleteToast("하이라이트를 삭제했어요")
    }
  }

  public func hideToast() {
    toastDismissTask?.cancel()
    toastDismissTask = nil
    toastMessage = nil
  }

  public func hideDeleteToast() {
    deleteToastDismissTask?.cancel()
    deleteToastDismissTask = nil
    deleteToastMessage = nil
  }
}

private extension LinkDetailViewModel {
  func saveChanges(onSuccess: () -> Void = {}) {
    do {
      try persistence?.save()
      onSuccess()
    } catch {
      showToast("저장하지 못했어요")
      print("save link detail failed: \(error)")
    }
  }

  func showToast(_ message: String) {
    toastDismissTask?.cancel()
    toastMessage = message

    toastDismissTask = Task {
      try? await Task.sleep(nanoseconds: 2_000_000_000)
      guard !Task.isCancelled else { return }
      await MainActor.run {
        hideToast()
      }
    }
  }

  func showDeleteToast(_ message: String) {
    deleteToastDismissTask?.cancel()
    deleteToastMessage = message

    deleteToastDismissTask = Task {
      try? await Task.sleep(for: .seconds(3))
      guard !Task.isCancelled else { return }
      await MainActor.run {
        hideDeleteToast()
      }
    }
  }
}
