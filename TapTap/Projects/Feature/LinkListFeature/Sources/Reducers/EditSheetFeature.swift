//
//  EditSheetFeature.swift
//  Feature
//
//  Created by 이안 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct EditSheetFeature {
  @ObservableState
  public struct State: Equatable {
    var link: ArticleItem?
  }
  
  public enum Action: Equatable {
    case dismissButtonTapped
    case moveButtonTapped
    case deleteButtonTapped
    case delegate(Delegate)
    
    public enum Delegate: Equatable {
      case dismissSheet
      case moveLink(ArticleItem?)
      case deleteLink(ArticleItem?)
    }
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dismissButtonTapped:
        return .send(.delegate(.dismissSheet))
        
      case .moveButtonTapped:
        return .send(.delegate(.moveLink(state.link)))
        
      case .deleteButtonTapped:
        return .send(.delegate(.deleteLink(state.link)))
        
      case .delegate:
        return .none
      }
    }
  }
}
