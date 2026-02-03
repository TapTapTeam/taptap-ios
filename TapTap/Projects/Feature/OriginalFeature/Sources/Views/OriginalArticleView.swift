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
struct OriginalArticleView: View {
  let store: StoreOf<OriginalArticleFeature>
  @State private var progress: Double = 0.0
  @State private var isWebViewLoaded: Bool = false
}

// MARK: - View
extension OriginalArticleView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(spacing: 0) {
        OriginalHeaderView(headerType: .article, onEditTapped: {
          store.send(.editButtonTapped)
        })
        
        if progress < 1.0 {
          ProgressView(value: progress, total: 1.0)
            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            .frame(height: 2)
        }
        
        if isWebViewLoaded {
          OriginalArticleWebView(articleItem: store.articleItem, progress: $progress)
            .ignoresSafeArea(edges: .bottom)
        } else {
          // 웹뷰가 로드되기 전까지 공간 차지 (또는 로딩 인디케이터)
          Spacer()
        }
      }
    }
    .task {
      // 화면 전환 애니메이션이 끝날 즈음에 웹뷰 로드 시작
      try? await Task.sleep(for: .seconds(0.1))
      isWebViewLoaded = true
    }
  }
}
