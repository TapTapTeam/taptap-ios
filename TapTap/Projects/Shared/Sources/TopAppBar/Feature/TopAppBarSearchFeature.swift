//
//  TopAppBarSearchFeature.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

@Reducer
public struct TopAppBarSearchFeature {
  @ObservableState
  public struct State: Equatable {
    public var searchText: String = ""
    var isSearchFieldFocused: Bool = false
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case backTapped
    case submit
    case clear
    case setSearchFieldFocus(Bool)
    case setSearchText(String)
    
    case delegate(DelegateAction)
    case binding(BindingAction<State>)
  }
  
  public enum DelegateAction: Equatable {
    case searchTriggered(query: String)
    case searchQueryChanged(String)
    case backButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
      .onChange(of: \.searchText) { oldValue, newValue in
        Reduce { state, action in
            .send(.delegate(.searchQueryChanged(newValue)))
        }
      }
    
    Reduce { state, action in
      switch action {
      case .backTapped:
        return .send(.delegate(.backButtonTapped))
        
      case .submit:
        return .send(.delegate(.searchTriggered(query: state.searchText)))
        
      case .clear:
        state.searchText = ""
        return .none
        
      case .setSearchFieldFocus(let isFocused):
        state.isSearchFieldFocused = isFocused
        return .none
        
      case let .setSearchText(text):
        state.searchText = text
        return .none
        
      case .delegate, .binding:
        return .none
      }
    }
  }
  
  public init() {}
}
