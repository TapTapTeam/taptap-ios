//
//  CategoryFavoriteView.swift
//  Feature
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import Shared

struct CategoryFavoriteView {
  @Bindable var store: StoreOf<CategoryFavoriteFeature>
}

extension CategoryFavoriteView: View {
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Color.clear
          .frame(width: 44, height: 44)
          .allowsHitTesting(false)
        Text("즐겨찾기")
          .font(.B1_SB)
          .foregroundStyle(.text1)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.vertical, 12)
        Button {
          store.send(.dismissButtonTapped)
        } label: {
          Image(icon: Icon.x)
            .resizable()
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .foregroundStyle(.icon)
            .padding(12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.trailing, 2)
      }
      .frame(height: 48)
      .padding(.vertical, 8)

      Button {
        store.send(.toggleButtonTapped)
      } label: {
        HStack(spacing: 0) {
          // TODO: 즐겨찾기 해제 시 디자인은 bookmark-slash 아이콘. 해당 자산이 없어
          // 우선 bookmark로 대체. 자산 추가되면 store.isFavorite 분기로 교체할 것.
          Image(icon: Icon.bookmark)
            .resizable()
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .foregroundStyle(.icon)
            .padding(10)
            .contentShape(Rectangle())
          Text(store.isFavorite ? "즐겨찾기 해제" : "즐겨찾기 추가")
            .font(.B1_M)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 40)
      }
      .buttonStyle(.plain)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading)
      .padding(.vertical, 4)
      .padding(.bottom, 40)
    }
  }
}
