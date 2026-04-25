//
//  OriginalEditView.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

// MARK: - Properties
public struct OriginalEditView: View {
  let store: StoreOf<OriginalEditFeature>
  
  public init(store: StoreOf<OriginalEditFeature>) {
    self.store = store
  }
  
  @State private var progress: Double = 0.0
  @State private var isWebViewLoaded: Bool = false
}

// MARK: - View
extension OriginalEditView {
  public var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(spacing: 0) {
        OriginalHeaderView(
          headerType: .edit,
          onCompleteTapped: { store.send(.completeButtonTapped)},
          onBackButtonTapped: { store.send(.backButtonTapped) }
        )
        
        if progress < 1.0 {
          ProgressView(value: progress, total: 1.0)
            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            .frame(height: 2)
        }
        
        if isWebViewLoaded {
          OriginalEditWebView(articleItem: store.articleItem, store: store, progress: $progress)
            .ignoresSafeArea(edges: .bottom)
        } else {
          Spacer()
        }
      }
    }
    .toolbar(.hidden)
    .task {
      try? await Task.sleep(for: .seconds(0.1))
      isWebViewLoaded = true
    }
  }
}
