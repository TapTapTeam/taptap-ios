//
//  AddCategoryFeature.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture

import AnalyticsKit
import DesignSystem
import Core
import Shared

@Reducer
public struct AddCategoryFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.analytics) var analytics
  
  @ObservableState
  public struct State: Equatable {
    var categoryName: String = ""
    var selectedIcon: CategoryIcon = .init(number: 1)
    var isAlert: Bool = false
    var textFieldStyle: JNTextFieldStyle = .default
    var isDuplicate: Bool = false
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case saveButtonTapped
    case cancelButtonTapped
    case backGestureSwiped
    case confirmAlertDismissed
    case confirmAlertConfirmButtonTapped
    case setDuplicate(Bool)
    case setTextFieldStyle(JNTextFieldStyle)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.categoryName):
        state.isDuplicate = false
        state.textFieldStyle = .default
        return .none
        
      case .saveButtonTapped:
        return .run { [name = state.categoryName] send in
          let categories = try swiftDataClient.category.fetchCategories()
          let isDuplicate = categories.contains { $0.categoryName.lowercased() == name.lowercased() } ||
            name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "전체"
          await send(.setDuplicate(isDuplicate))
        }
        
      case .setDuplicate(let isDuplicate):
        state.isDuplicate = isDuplicate
        state.textFieldStyle = isDuplicate ? .errorCaption : .default
        
        if !isDuplicate {
          let newCategory = CategoryItem(
            categoryName: state.categoryName,
            icon: state.selectedIcon
          )
          return .run { [analytics] send in
            try swiftDataClient.category.addCategory(newCategory)
            // 저장이 끝난 뒤 다시 세어야 방금 만든 것까지 포함된다. 실패하면 -1 → "unknown" 구간.
            let totalCount = (try? swiftDataClient.category.fetchCategories().count) ?? -1
            analytics.track(ConversionEvent.categoryCreated(totalCount: totalCount))
            analytics.setUserProperty(.categoryCount(totalCount))
            NotificationCenter.default.post(name: .categoryAdded, object: nil)
            await send(.delegate(.route(.back)))
          }
        } else {
          return .none
        }
        
      case .setTextFieldStyle(let style):
        state.textFieldStyle = style
        return .none
        
      case .binding:
        return .none
        
      case .backGestureSwiped, .cancelButtonTapped:
        state.isAlert = true
        return .none
        
      case .confirmAlertDismissed:
        state.isAlert = false
        return .none
        
      case .confirmAlertConfirmButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
