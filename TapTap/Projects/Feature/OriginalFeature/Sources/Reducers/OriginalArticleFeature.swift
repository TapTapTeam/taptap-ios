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
    var path: StackState<Path.State> = .init()
    
    var articleItem: ArticleItem
  }
  
  public enum Action: Equatable {
    case path(StackActionOf<Path>)
    
    case editButtonTapped
    case backButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .editButtonTapped:
        state.path.append(.originalEdit(.init(articleItem: state.articleItem)))
        return .none
              
      case .backButtonTapped:
        return .none
        
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    
    OriginalNavigationReducer()
  }
  
  public init() {}
}
