//
//  RecentLinkFeature.swift
//  Feature
//
//  Created by 여성일 on 10/21/25.
//

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct RecentLinkFeature {
  @ObservableState
  public struct State: Equatable {
    var recentLinkItem: [ArticleItem] = []
  }
  
  public enum Action: Equatable {
    case onAppear
    case recentLinkResponse([ArticleItem])
    case recentLinkTapped(ArticleItem)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let links = try swiftDataClient.link.fetchRecentLinks()
          await send(.recentLinkResponse(links))
        }
      
      case .recentLinkResponse(let items):
        state.recentLinkItem = items
        return .none
      
      case .recentLinkTapped(let item):
        return .send(.delegate(.route(.linkDetail(item))))
      
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
