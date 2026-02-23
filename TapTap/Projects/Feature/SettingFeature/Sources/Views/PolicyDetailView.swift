//
//  PolicyDetailView.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import Core

public struct PolicyDetailView: View {
  @Bindable var store: StoreOf<PolicyDetailFeature>
  
  public init(store: StoreOf<PolicyDetailFeature>) {
    self.store = store
  }
}

extension PolicyDetailView {
  public var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      VStack(spacing: .zero) {
        TopAppBarDefaultRightIconx(title: store.title) {
          store.send(.backButtonTapped)
        }
        
        ScrollView {
          Text(.init(store.text))
            .font(.C2)
            .foregroundStyle(.caption2)
            .padding(20)
        }
      }
    }
    .toolbar(.hidden)
  }
}
