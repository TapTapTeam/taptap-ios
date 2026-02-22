//
//  MyCategoryCollection.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import Shared

public struct MyCategoryCollectionView {
  @Bindable var store: StoreOf<MyCategoryCollectionFeature>
}

extension MyCategoryCollectionView: View {
  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      ZStack {
        VStack(spacing: 0) {
          TopAppBarDefaultNoSearch(
            title: "내 카테고리 모음",
            onTapBackButton: { store.send(.backButtonTapped) },
            onTapSettingButton: { store.send(.settingButtonTapped) }
          )
          Button {
            store.send(.totalLinkTapped)
          } label: {
            HStack(spacing: 0) {
              DesignSystemAsset.categoryIcon(number: 16)
                .resizable()
                .frame(width: 28, height: 28)
                .padding(.trailing, 8)
              Text(CategoryNamespace.total)
                .font(.B1_SB)
                .foregroundStyle(.text1)
                .frame(maxWidth: .infinity, alignment: .leading)
              Spacer()
              Text("\(store.allLinksCount)개")
                .font(.B1_M)
                .foregroundStyle(.caption1)
              Image(icon: Icon.chevronRight)
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .foregroundStyle(.text1)
                .padding(.leading, 4)
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
          }
          .frame(height: 64)
          .background(.bl1)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(.horizontal, 20)
          .padding(.top, 8)
          .buttonStyle(.plain)
          MyCategoryGridView(
            store: store.scope(
              state: \.myCategoryGrid,
              action: \.myCategoryGrid
            )
          )
          .padding(.top, 20)
        }
        .background(DesignSystemAsset.background.swiftUIColor)
        .toolbar(.hidden)
        
        if let sheetStore = store.scope(
          state: \.settingModal,
          action: \.settingModal
        ) {
          BottomSheetContainerView(onDismiss: {
            store.send(.settingModal(.dismissButtonTapped))
          }) {
            CategorySettingView(store: sheetStore)
          }
          .transition(.move(edge: .bottom).combined(with: .opacity))
          .zIndex(1)
        }
      }
      .toolbar(.hidden)
      .onAppear {
        store.send(.onAppear)
      }
      .task {
        NotificationCenter.default.addObserver(
          forName: .categoryDeleted,
          object: nil,
          queue: .main
        ) { notification in
          let count = (notification.object as? [String: Int])?["deletedCount"] ?? 0
          store.send(.showToast("\(count)개의 카테고리를 삭제했어요"))
        }
        NotificationCenter.default.addObserver(
          forName: .categoryAdded,
          object: nil,
          queue: .main
        ) { _ in
          store.send(.showToast("카테고리를 추가했어요"))
        }
      }
      .overlay(alignment: .bottom) {
        if store.showToast {
          AlertIconBanner(
            icon: Image(icon: Icon.badgeCheck),
            title: store.toastMessage,
            iconColor: .badgeColor
          )
          .zIndex(1)
          .padding(.horizontal, 20)
          .padding(.bottom, 8)
        }
      }
      .animation(.easeInOut(duration: 0.3), value: store.showToast)
    } destination: { store in
      switch store.case {
      case let .editCategory(store):
        EditCategoryView(store: store)
      case let .editCategoryIconName(store):
        EditCategoryIconNameView(store: store)
      case let .addCategory(store):
        AddCategoryView(store: store)
      case let .deleteCategory(store):
        DeleteCategoryView(store: store)
      }
    }
  }
}

#Preview {
  MyCategoryCollectionView(
    store: Store(initialState: MyCategoryCollectionFeature.State()) {
      MyCategoryCollectionFeature()
    })
}
