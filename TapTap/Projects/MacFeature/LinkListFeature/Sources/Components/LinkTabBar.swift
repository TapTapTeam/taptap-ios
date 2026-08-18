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
  let onNewTab: () -> Void

  var body: some View {
    GeometryReader { geometry in
      let plusButtonWidth: CGFloat = 36
      let tabWidth = calculatedTabWidth(
        totalWidth: geometry.size.width,
        plusButtonWidth: plusButtonWidth
      )

      HStack(spacing: 0) {
        ForEach(tabs) { tab in
          tabItem(tab, width: tabWidth)
        }

        plusButton(width: plusButtonWidth)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .clipped()
    }
    .frame(height: 36)
    .background(Color.n10)
    .overlay(alignment: .bottom) {
      Divider()
    }
  }
}

private extension LinkTabBar {
  func calculatedTabWidth(totalWidth: CGFloat, plusButtonWidth: CGFloat) -> CGFloat {
    guard !tabs.isEmpty else { return 0 }

    let availableTabsWidth = max(totalWidth - plusButtonWidth, 0)
    return max(availableTabsWidth / CGFloat(tabs.count), 1)
  }

  func plusButton(width: CGFloat) -> some View {
    Button(action: onNewTab) {
      DesignSystemAsset.macPlus.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(.iconGray)
        .frame(width: width, height: 14)
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }

  func tabItem(_ tab: LinkListViewModel.OpenedLinkTab, width: CGFloat) -> some View {
    let isSelected = tab.id == selectedTabID

    return HStack(spacing: 10) {
      Text(tab.title)
        .font(.C1)
        .foregroundStyle(.text1)
        .lineLimit(1)

      Spacer(minLength: 8)

      if isSelected {
        Button {
          onClose(tab.id)
        } label: {
          DesignSystemAsset.macX.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.iconGray)
            .frame(width: 14, height: 14)
        }
        .buttonStyle(.plain)
      }
    }
    .padding(.horizontal, 14)
    .frame(width: width, height: 36)
    .background(isSelected ? Color.n0 : Color.background)
    .overlay(alignment: .trailing) {
      Rectangle()
        .fill(Color.divider2)
        .frame(width: 1)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      onSelect(tab.id)
    }
  }
}
