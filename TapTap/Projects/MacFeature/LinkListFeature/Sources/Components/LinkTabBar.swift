//
//  LinkTabBar.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 5/11/26.
//

import SwiftUI

import DesignSystem

struct LinkTabBar: View {
  let tabs: [LinkListViewModel.OpenedLinkTab]
  let selectedTabID: String?
  let onSelect: (String) -> Void
  let onClose: (String) -> Void

  var body: some View {
    HStack(spacing: 0) {
      ForEach(tabs) { tab in
        tabItem(tab)
      }

      Image(systemName: "plus")
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(.iconGray)
        .frame(width: 56, height: 33)

      Spacer(minLength: 0)
    }
    .frame(height: 33)
    .background(Color.n10)
    .overlay(alignment: .bottom) {
      Divider()
    }
  }
}

private extension LinkTabBar {
  func tabItem(_ tab: LinkListViewModel.OpenedLinkTab) -> some View {
    HStack(spacing: 10) {
      Text(tab.title)
        .font(.C1)
        .foregroundStyle(.text1)
        .lineLimit(1)

      Spacer(minLength: 8)

      Button {
        onClose(tab.id)
      } label: {
        Image(systemName: "xmark")
          .font(.system(size: 10, weight: .semibold))
          .foregroundStyle(.iconGray)
          .frame(width: 20, height: 20)
      }
      .buttonStyle(.plain)
    }
    .padding(.horizontal, 14)
    .frame(width: 208, height: 33)
    .background(tab.id == selectedTabID ? Color.n0 : Color.n10)
    .overlay(alignment: .trailing) {
      Divider()
    }
    .contentShape(Rectangle())
    .onTapGesture {
      onSelect(tab.id)
    }
  }
}
