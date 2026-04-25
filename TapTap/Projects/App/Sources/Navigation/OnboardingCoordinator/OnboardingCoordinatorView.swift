//
//  OnboardingCoordinatorView.swift
//  TapTap
//
//  Created by 여성일 on 2/24/26.
//

import SwiftUI

import ComposableArchitecture

import OnboardingFeature

public struct OnboardingCoordinatorView: View {
  let store: StoreOf<OnboardingCoordinator>

  public init(store: StoreOf<OnboardingCoordinator>) {
    self.store = store
  }

  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: \.path)) {
      OnboardingView(store: store.scope(state: \.onboarding, action: \.onboarding))
        .toolbar(.hidden)
    } destination: { pathStore in
      switch pathStore.case {
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
