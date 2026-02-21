//
//  ArticleFilterFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct ArticleFilterFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  public struct State: Equatable {
    var link: [ArticleItem] = []
    var sortOrder: SortOrder = .latest
    var selectedLink: ArticleItem? = nil
  }
  
  public enum SortOrder: Equatable {
    case latest
    case oldest
  }
  
  public enum Action: Equatable {
    case listCellTapped(ArticleItem)
    case listCellLongPressed(ArticleItem)
    case sortOrderChanged(SortOrder)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case openLinkDetail(ArticleItem)
      case longPressed(ArticleItem)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .listCellTapped(let article):
        linkNavigator.push(.linkDetail, article)
        return .none
        
      case let .listCellLongPressed(link):
        return .send(.delegate(.longPressed(link)))
        
      case let .sortOrderChanged(order):
        state.sortOrder = order
        
        switch order {
        case .latest:
          state.link.sort { $0.createAt > $1.createAt }
        case .oldest:
          state.link.sort { $0.createAt < $1.createAt }
        }
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}
