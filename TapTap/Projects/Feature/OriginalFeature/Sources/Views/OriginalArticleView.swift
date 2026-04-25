//
//  OriginalArticleView.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

// MARK: - Properties
public struct OriginalArticleView: View {
  @Bindable var store: StoreOf<OriginalArticleFeature>
  
  public init(store: StoreOf<OriginalArticleFeature>) {
    self.store = store
  }
  
  @State private var progress: Double = 0.0
  @State private var isWebViewLoaded: Bool = false
}

// MARK: - View
extension OriginalArticleView {
  public var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(spacing: 0) {
        OriginalHeaderView(
          headerType: .article,
          onEditTapped: { store.send(.editButtonTapped)},
          onBackButtonTapped: { store.send(.backButtonTapped) }
        )
        
        if progress < 1.0 {
          ProgressView(value: progress, total: 1.0)
            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            .frame(height: 2)
        }
        
        if isWebViewLoaded {
          OriginalArticleWebView(articleItem: store.articleItem, progress: $progress)
            .ignoresSafeArea(edges: .bottom)
        } else {
          Spacer()
        }
      }
    }
    .toolbar(.hidden)
    .onAppear {
      isWebViewLoaded = true
    }
  }
}
