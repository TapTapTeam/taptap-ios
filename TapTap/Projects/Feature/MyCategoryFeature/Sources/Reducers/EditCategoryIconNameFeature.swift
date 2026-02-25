//
//  EditCategoryIconNameFeature.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import Core
import Shared

@Reducer
public struct EditCategoryIconNameFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  public struct State: Equatable {
    var categoryName: String
    var category: CategoryItem?
    var selectedIcon: CategoryIcon?
    var isDuplicate: Bool = false
    var textFieldStyle: JNTextFieldStyle = .default
    var isAlert: Bool = false
    
    public init(category: CategoryItem?) {
      self.category = category
      self.categoryName = category?.categoryName ?? ""
      self.selectedIcon = category?.icon ?? .init(number: 1)
    }
  }
  
  public enum Action: Equatable {
    case compeleteButtonTapped
    case backButtonTapped
    case setCategoryName(String)
    case selectIcon(CategoryIcon?)
    case setDuplicate(Bool)
    case setTextFieldStyle(JNTextFieldStyle)
    case backGestureSwiped
    case confirmAlertDismissed
    case confirmAlertConfirmButtonTapped
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .setCategoryName(name):
        state.categoryName = name
        state.isDuplicate = false
        state.textFieldStyle = .default
        return .none
        
      case let .selectIcon(icon):
        state.selectedIcon = icon
        return .none
        
      case .compeleteButtonTapped:
        return .run { [category = state.category, name = state.categoryName] send in
          let categories = try swiftDataClient.category.fetchCategories()
          let isDuplicate = categories.contains { $0.categoryName.lowercased() == name.lowercased() && $0.id != category?.id } || name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "전체"
          
          await send(.setDuplicate(isDuplicate))
        }
        
      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case let .setDuplicate(isDuplicate):
        state.isDuplicate = isDuplicate
        state.textFieldStyle = isDuplicate ? .errorCaption : .default
        
        if !isDuplicate {
          return .run { [id = state.category?.id, name = state.categoryName, icon = state.selectedIcon] send in
            guard let id, let icon else { return }
            await MainActor.run {
              do {
                try swiftDataClient.category.updateCategoryItem(id: id, name: name, icon: icon)
                NotificationCenter.default.post(name: .categoryEdited, object: nil)
              } catch {
                print("카테고리 업데이트 실패 \(error)")
              }
            }
            await send(.delegate(.route(.back)))
          }
        } else {
          return .none
        }
        
        case let .setTextFieldStyle(style):
          state.textFieldStyle = style
          return .none
          
      case .backGestureSwiped:
        state.isAlert = true
        return .none
        
      case .confirmAlertDismissed:
        state.isAlert = false
        return .none
        
      case .confirmAlertConfirmButtonTapped:
        state.isAlert = false
        return .send(.delegate(.route(.back)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}

