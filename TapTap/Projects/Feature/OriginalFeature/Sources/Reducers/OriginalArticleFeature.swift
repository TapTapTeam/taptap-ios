//
//  OriginalArticleFeature.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import Foundation

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct OriginalArticleFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  public struct State: Equatable {
    var articleItem: ArticleItem
  }
  
  public enum Action: Equatable {
    case editButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .editButtonTapped:
        let payload = OriginalPayload(articleItem: state.articleItem)
        linkNavigator.push(.originalEdit, payload)
        linkNavigator.remove(.originalArticle)
        return .none
      }
    }
  }
  
  public init() {}
}
