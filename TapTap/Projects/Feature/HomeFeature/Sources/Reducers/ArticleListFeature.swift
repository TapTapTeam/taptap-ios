//
//  ArticleListFeature.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct ArticleListFeature {
  
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  public struct State: Equatable {
    var articles: [ArticleItem] = []
    var showMoreLink: Bool = false
    var showLinkDetail: Bool = false
    var showTipCard: Bool = true
  }
  
  public enum Action: Equatable {
    case moreLinkButtonTapped
    case listCellTapped(ArticleItem)
    case toggleTipCard
    case tipCardTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .moreLinkButtonTapped:
        return .run { _ in
          linkNavigator.push(.linkList, nil)
        }
        
      case .listCellTapped(let article):
        linkNavigator.push(.linkDetail, article)
        return .none
        
      case .tipCardTapped:
        linkNavigator.push(.setting, nil)
        return .none
        //return .send(.delegate(.route(.setting)))
        
      case .toggleTipCard:
        state.showTipCard = false
        return .none
      }
    }
  }
  
  public init() {}
}
