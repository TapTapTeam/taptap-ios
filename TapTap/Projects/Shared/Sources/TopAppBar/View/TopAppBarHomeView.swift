//
//  TopAppBarHomeView.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct TopAppBarHomeView {
  let store: StoreOf<TopAppBarHomeFeature>
  
  public init(store: StoreOf<TopAppBarHomeFeature>) {
    self.store = store
  }
}

extension TopAppBarHomeView: View {
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TopAppBarHome(
        onTapSearchButton: { viewStore.send(.tapSearchButton) },
        onTapSettingButton: { viewStore.send(.tapSettingButton) }
      )
    }
  }
}
