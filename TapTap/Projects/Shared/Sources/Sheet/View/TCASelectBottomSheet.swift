//
//  TCASelectBottomSheet.swift
//  Feature
//
//  Created by 여성일 on 10/22/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

// MARK: - Properties
public struct TCASelectBottomSheet: View {
  let title: String
  let buttonTitle: String
  let store: StoreOf<SelectBottomSheetFeature>
  
  public init(
    title: String,
    buttonTitle: String,
    store: StoreOf<SelectBottomSheetFeature>
  ) {
    self.title = title
    self.buttonTitle = buttonTitle
    self.store = store
  }
}

// MARK: - View
extension TCASelectBottomSheet {
  public var body: some View {
    SelectBottomSheet(
      sheetTitle: title,
      items: store.categories.elements,
      categoryButtonTapped: { category in store.send(.categoryTapped(category)) },
      selectButtonTapped: { store.send(.selectButtonTapped) },
      dismissButtonTapped: { store.send(.closeTapped) },
      selectedCategory: store.selectedCategory,
      buttonTitle: buttonTitle
    )
    .onAppear {
      
    }
  }
}

#Preview {
  TCASelectBottomSheet(
    title: "카테고리 선택",
    buttonTitle: "선택하기",
    store: Store(
      initialState: SelectBottomSheetFeature.State(),
      reducer: { SelectBottomSheetFeature() }
    )
  )
}
