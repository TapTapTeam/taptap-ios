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
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
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
    } destination: { store in
      switch store.case {
      case let .onboardingSafariSetting(store):
        OnboardingSafariSettingView(store: store)
      case let .onboardingHighlightMemo(store):
        OnboardingHighlightMemoView(store: store)
      case let .onboardingHighlightGuide(store):
        OnboardingHighlightGuideView(store: store)
      case let .onboardingShare(store):
        OnboardingShareView(store: store)
      case let .onboardingShareGuide(store):
        OnboardingShareGuideView(store: store)
      case let .onboardingFinish(store):
        OnboardingFinishView(store: store)
      }
    }
  }
}
