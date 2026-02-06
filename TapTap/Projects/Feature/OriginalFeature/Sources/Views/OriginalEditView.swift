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
struct OriginalEditView: View {
  let store: StoreOf<OriginalEditFeature>
  @State private var progress: Double = 0.0
  @State private var isWebViewLoaded: Bool = false
}

// MARK: - View
extension OriginalEditView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(spacing: 0) {
        OriginalHeaderView(headerType: .edit, onCompleteTapped:  {
          store.send(.completeButtonTapped)
        })
        
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
    .task {
      try? await Task.sleep(for: .seconds(0.1))
      isWebViewLoaded = true
    }
  }
}
