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
  @State private var webViewLoadErrorMessage: String?
  @State private var webViewRetryID = UUID()
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
          ZStack {
            OriginalArticleWebView(
              articleItem: store.articleItem,
              progress: $progress,
              onLoadEvent: { event in
                switch event {
                case .succeeded:
                  webViewLoadErrorMessage = nil
                case .failed(let message):
                  webViewLoadErrorMessage = message
                }
              }
            )
            .id(webViewRetryID)
            .ignoresSafeArea(edges: .bottom)
            
            if let webViewLoadErrorMessage {
              webViewErrorView(message: webViewLoadErrorMessage)
            }
          }
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
  
  private func webViewErrorView(message: String) -> some View {
    VStack(spacing: 20) {
      Image(uiImage: DesignSystemAsset.emptyImage.image)
        .resizable()
        .frame(width: 120, height: 120)
      
      VStack(spacing: 8) {
        Text(message)
          .font(.B1_SB)
          .foregroundStyle(.text1)
        
        Text("네트워크 상태를 확인한 뒤 다시 시도해 주세요.")
          .font(.B2_M)
          .foregroundStyle(.caption3)
      }
      
      MainButton("다시 시도") {
        progress = 0.0
        webViewLoadErrorMessage = nil
        webViewRetryID = UUID()
      }
    }
    .multilineTextAlignment(.center)
    .padding(.horizontal, 24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.background)
  }
}
