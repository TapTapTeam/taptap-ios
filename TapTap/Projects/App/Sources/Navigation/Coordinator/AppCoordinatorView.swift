//
//  AppCoordinatorView.swift
//  TapTap
//
//  Created by 여성일 on 2/23/26.
//

import SwiftUI
import ComposableArchitecture

import HomeFeature
import OnboardingFeature
import AddLinkFeature
import SettingFeature

public struct AppCoordinatorView: View {
  let store: StoreOf<AppCoordinator>

  public init(store: StoreOf<AppCoordinator>) {
    self.store = store
  }

  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: \.path)) {
      HomeView(store: store.scope(state: \.home, action: \.home))
        .toolbar(.hidden)
    } destination: { store in
      switch store.case {
      case let .setting(store):
        SettingView(store: store)
      case let .extensionSetting(store):
        ExtensionSettingView(store: store)
      case let .shareSetting(store):
        ShareSettingView(store: store)
      case let .favoriteSetting(store):
        FavoriteSettingView(store: store)
      case let .policyDetail(store):
        PolicyDetailView(store: store)
      case let .openSourceList(store):
        OpenSourceListView(store: store)
      case let .onboardingHighlightGuide(store):
        OnboardingHighlightGuideView(store: store)
      }
    }
  }
}
