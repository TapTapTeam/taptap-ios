//
//  OnboardingView.swift
//  Feature
//
//  Created by 여성일 on 1/12/26.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct OnboardingView {
  @Bindable public var store: StoreOf<OnboardingFeature>
  
  public init(store: StoreOf<OnboardingFeature>) {
    self.store = store
  }
}

extension OnboardingView: View {
  public var body: some View {
    VStack {
      OnboardingTitleImage(
        title: .introTitle,
        description: .introDescription,
        image: DesignSystemAsset.onboardingService.swiftUIImage,
        showPage: false,
        currentPage: 0
      )
      .padding(.top, 60)
      
      Spacer()
      
      MainButton("시작하기", hasGradient: true) {
        store.send(.startButtonTapped)
      }
      .buttonStyle(.plain)
      .padding(.bottom, 8)
    }
    .background(Color.background)
    .toolbar(.hidden)
  }
}
