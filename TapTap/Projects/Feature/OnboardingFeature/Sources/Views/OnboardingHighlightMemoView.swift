//
//  OnboardingHighlightMemoView.swift
//  Feature
//
//  Created by 여성일 on 1/13/26.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

struct OnboardingHighlightMemoView {
  let store: StoreOf<OnboardingHighlightMemoFeature>
}

extension  OnboardingHighlightMemoView: View {
  var body: some View {
    VStack(spacing: 0) {
      TopAppBarDefaultRightIconx(title: "") {
        store.send(.backButtonTapped)
      }
      OnboardingTitleImage(
        title: .highlightMemoTitle,
        description: .highlightMemoDescription,
        image: DesignSystemAsset.highlightMemo.swiftUIImage,
        showPage: true,
        currentPage: 2
      )
      Spacer()
      VStack(spacing: 0) {
        MainButton("다음", hasGradient: true) {
          store.send(.nextButtonTapped)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 24)
        
        Button(action: {
          store.send(.skipButtonTapped)
        }) {
          Text("건너뛰기")
            .font(.C2)
            .foregroundStyle(.caption2)
            .underline()
        }
        .buttonStyle(.plain)
      }
      .background(Color.background)
      .padding(.bottom, 8)
    }
    .background(Color.background)
    .toolbar(.hidden)
  }
}
