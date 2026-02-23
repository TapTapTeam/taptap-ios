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
  @ObservableState
  public struct State: Equatable {
    var articleItem: ArticleItem
    
    public init(articleItem: ArticleItem) {
      self.articleItem = articleItem
    }
  }
  
  public enum Action: Equatable {
    case editButtonTapped
    case backButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
    
    OriginalNavigationReducer()
  }
  
  public init() {}
}
