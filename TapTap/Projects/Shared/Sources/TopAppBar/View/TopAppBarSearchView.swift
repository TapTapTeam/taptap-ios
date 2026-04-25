//
//  TopAppBarSearchView.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct TopAppBarSearchView {
  @State var store: StoreOf<TopAppBarSearchFeature>
  
  @FocusState private var isSearchFieldFocused: Bool
  
  public init(
    store: StoreOf<TopAppBarSearchFeature>
  ) {
    self.store = store
  }
}

extension TopAppBarSearchView: View {
  public var body: some View {
    TopAppBarSearch(
      text: $store.searchText,
      isFocused: $isSearchFieldFocused,
      onBack: { store.send(.backTapped) },
      onSubmit: { store.send(.submit) },
      onClear: { store.send(.clear) }
    )
    .bind($store.isSearchFieldFocused, to: $isSearchFieldFocused)
  }
}
