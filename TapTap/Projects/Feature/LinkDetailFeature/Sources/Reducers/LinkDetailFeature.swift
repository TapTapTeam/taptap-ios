//
//  LinkDetailFeature.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import Core
import Shared

@Reducer
public struct LinkDetailFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient

  private enum CancelID { case editNotification }
  
  @ObservableState
  public struct State: Equatable {
    var link: ArticleItem
    var isEditingTitle = false
    var editedTitle = ""
    var editedMemo = ""
    var isDeleted = false
    var showToast: Bool = false
    
    var summary: SummaryFeature.State
    
    public init(article: ArticleItem) {
      self.link = article
      self.isEditingTitle = false
      self.editedTitle = ""
      self.editedMemo = ""
      self.isDeleted = false
      self.showToast = false
      self.summary = SummaryFeature.State(article: article)
    }
  }
  
  public enum Action: Equatable {
    case onAppear
    
    /// 제목
    case editButtonTapped
    case titleChanged(String)
    case titleFocusChanged(Bool)
    case saveIfNeeded
    case saveSucceeded
    case saveFailed(String)
    
    /// 메모
    case memoChanged(String)
    case memoFocusChanged(Bool)
    case saveMemoIfNeeded
    case saveMemoSucceeded
    case saveMemoFailed(String)
    
    /// 삭제
    case deleteTapped
    case deleteSucceeded
    case deleteFailed(String)
    
    /// 원문보기
    case originalArticleTapped
    case refreshed(ArticleItem?)
    
    /// 토스트
    case editCompletedNotification
    case showToast
    case dismissToast
    
    case summary(SummaryFeature.Action)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.summary, action: \.summary) {
      SummaryFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.editedTitle = state.link.title
        state.editedMemo  = state.link.userMemo
        return .merge(
          .run { [linkID = state.link.id] send in
            do {
              try swiftDataClient.link.updateLinkLastViewed(linkID)
            } catch {
              print("Failed to update last viewed date: \(error)")
            }
            let linkItem = try swiftDataClient.link.fetchLink(id: linkID)
            await send(.refreshed(linkItem))
          },
          .run { send in
            for await _ in NotificationCenter.default.notifications(named: .editCompleted) {
              await send(.editCompletedNotification)
            }
          }
            .cancellable(id: CancelID.editNotification)
        )
        
        /// 제목 편집
      case .editButtonTapped:
        state.isEditingTitle = true
        state.editedTitle = state.link.title
        return .none
        
      case .titleChanged(let text):
        state.editedTitle = text
        return .none
        
      case .titleFocusChanged(false):
        let current = state.link.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let next = state.editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        state.isEditingTitle = false
        if !next.isEmpty, next != current {
          return .send(.saveIfNeeded)
        }
        return .none
        
      case .titleFocusChanged(true):
        return .none
        
      case .saveIfNeeded:
        let id = state.link.id
        let newTitle = state.editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !newTitle.isEmpty, newTitle != state.link.title else { return .none }
        return .run { send in
          do {
            try swiftDataClient.link.updateLinkTitle(id, newTitle)
            await send(.saveSucceeded)
          } catch {
            await send(.saveFailed(error.localizedDescription))
          }
        }
        
      case .saveSucceeded:
        state.link.title = state.editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        return .none
        
      case .saveFailed(let error):
        print("제목 수정 실패:", error)
        return .none
        
        /// 메모
      case let .memoChanged(text):
        state.editedMemo = text
        return .none
        
      case let .memoFocusChanged(hasFocus):
        if hasFocus == false {
          return .send(.saveMemoIfNeeded)
        }
        return .none
        
      case .saveMemoIfNeeded:
        let next = state.editedMemo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard next != state.link.userMemo else { return .none }
        let id = state.link.id
        
        return .run { send in
          do {
            try swiftDataClient.link.updateLinkMemo(id, next)
            await send(.saveMemoSucceeded)
          } catch {
            await send(.saveMemoFailed(error.localizedDescription))
          }
        }
        
      case .saveMemoSucceeded:
        state.link.userMemo = state.editedMemo.trimmingCharacters(in: .whitespacesAndNewlines)
        return .none
        
      case .saveMemoFailed(let error):
        print("save memo failed:", error)
        return .none
        
        /// 삭제
      case .deleteTapped:
        let id = state.link.id
        return .run { send in
          do {
            try swiftDataClient.link.deleteLinkById(id)
            await send(.deleteSucceeded)
          } catch {
            await send(.deleteFailed(error.localizedDescription))
          }
        }
        
      case .deleteSucceeded:
        state.isDeleted = true
        NotificationCenter.default.post(
          name: .linkDeleted,
          object: ["deletedCount": 1]
        )
        return .none
        
      case .deleteFailed(let error):
        print("링크 삭제 실패:", error)
        return .none
        
        /// 원문보기
      case .originalArticleTapped:
        return .send(.delegate(.route(.originalArticle(state.link))))
        
      case .refreshed(let item):
        if let item {
          state.link = item
          state.summary.article = item
        }
        return .none
        
      case .editCompletedNotification:
        print("수정 완료")
        return .send(.showToast)
        
      case .showToast:
        state.showToast = true
        return .run { send in
          try await Task.sleep(for: .seconds(2))
          await send(.dismissToast)
        }
        
      case .dismissToast:
        state.showToast = false
        return .none
        
      case .summary:
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
