//
//  SelectBottomSheetFeature.swift
//  Feature
//
//  Created by 여성일 on 10/22/25.
//

import Foundation

import ComposableArchitecture

import DesignSystem
import Domain

@Reducer
public struct SelectBottomSheetFeature {
  @ObservableState
  public struct State: Equatable {
    public var categories: IdentifiedArrayOf<CategoryProps> = []
    public var selectedCategory: String?
    
    public init(
      categories: IdentifiedArrayOf<CategoryProps> = [],
      selectedCategory: String? = nil
    ) {
      self.categories = categories
      self.selectedCategory = selectedCategory
    }
  }
  
  public enum Action: Equatable {
    case categoryTapped(String)
    case selectButtonTapped
    case closeTapped
    
    case delegate(DelegateAction)
  }
  
  public enum DelegateAction: Equatable {
    case categorySelected(String?)
    case dismiss
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.swiftDataClient) var swiftDataClient

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {        
      case .categoryTapped(let category):
        print(category)
        state.selectedCategory = category
        return .none
        
      case .closeTapped:
        return .run { _ in await self.dismiss() }
        
      case .selectButtonTapped:
        return .run { [selectedCategory = state.selectedCategory] send in
          await send(.delegate(.categorySelected(selectedCategory)))
          await self.dismiss()
        }
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
