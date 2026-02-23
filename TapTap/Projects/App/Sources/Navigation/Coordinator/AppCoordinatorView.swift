//
//  AppCoordinatorView.swift
//  TapTap
//
//  Created by 여성일 on 2/23/26.
//

import SwiftUI
import ComposableArchitecture

import AddLinkFeature
import HomeFeature
import LinkDetailFeature
import MyCategoryFeature
import OnboardingFeature
import OriginalFeature
import SearchFeature
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
      // AddLinkFeature
      case let .addLink(store):
        AddLinkView(store: store)
        
      // LinkDetailFeature
      case let .linkDetail(store):
        LinkDetailView(store: store)
        
      // LinkListFeature
        
      // MyCategoryFeature
      case let .addCategory(store):
        AddCategoryView(store: store)
        
      // OnboardingFeature
      case let .onboardingHighlightGuide(store):
        OnboardingHighlightGuideView(store: store)
        
      // OriginalFeature
      case let .originalArticle(store):
        OriginalArticleView(store: store)
        
      // SearchFeature
      case let .search(store):
        SearchView(store: store)
        
      // SettingFeature
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
      }
    }
  }
}
