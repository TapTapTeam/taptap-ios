//
//  OriginalEditFeature.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import Foundation

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct OriginalEditFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  public struct State: Equatable {
    var articleItem: ArticleItem
    var isDataRequestTriggered: Bool = false
    
    public init(articleItem: ArticleItem) {
      self.articleItem = articleItem
    }
  }
  
  public enum Action: Equatable {
    case completeButtonTapped
    case backButtonTapped
    case highlightsDataResponse([HighlightPayload])
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce {
      state,
      action in
      switch action {
      case .completeButtonTapped:
        state.isDataRequestTriggered = true
        return .none
        
      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .highlightsDataResponse(let highlights):
        return .run { [linkID = state.articleItem.id] send in
          do {
            let highlights = highlights.map { payload in
              HighlightItem(
                id: payload.id,
                sentence: payload.sentence,
                type: payload.type,
                createdAt: Date(),
                comments: payload.comments
              )
            }
            try swiftDataClient.highlight.updateHighlightsForLink(linkID: linkID, highlights: highlights)

            await send(.delegate(.route(.back)))
            
            try await Task.sleep(for: .milliseconds(300))
            NotificationCenter.default.post(name: .editCompleted, object: nil)
          } catch {
            print("저장 실패")
          }
        }
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
