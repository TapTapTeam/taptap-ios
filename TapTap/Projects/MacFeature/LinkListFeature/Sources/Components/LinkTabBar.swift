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
      let layout = calculatedLayout(
        totalWidth: geometry.size.width,
        plusButtonWidth: plusButtonWidth
      )

      HStack(spacing: 0) {
        HStack(spacing: 0) {
          ForEach(tabs) { tab in
            tabItem(tab, width: layout.tabWidth)
          }

          if !layout.isOverflowing {
            plusButton(width: plusButtonWidth)
          }
        }
        .frame(maxWidth: layout.isOverflowing ? .infinity : nil, alignment: .leading)
        .clipped()

        if layout.isOverflowing {
          plusButton(width: plusButtonWidth)
        } else {
          Spacer(minLength: 0)
        }
      }
    }
    .frame(height: 36)
    .background(Color.n10)
    .overlay(alignment: .bottom) {
      Divider()
    }
  }
}

private extension LinkTabBar {
  func calculatedLayout(totalWidth: CGFloat, plusButtonWidth: CGFloat) -> (tabWidth: CGFloat, isOverflowing: Bool) {
    let maxWidth: CGFloat = 208
    guard !tabs.isEmpty else {
      return (maxWidth, false)
    }

    let availableTabsWidth = max(totalWidth - plusButtonWidth, 0)
    let idealTabsWidth = CGFloat(tabs.count) * maxWidth
    let isOverflowing = idealTabsWidth > availableTabsWidth
    guard isOverflowing else {
      return (maxWidth, false)
    }

    let dividedWidth = availableTabsWidth / CGFloat(tabs.count)

    return (max(dividedWidth, 1), true)
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
    HStack(spacing: 10) {
      Text(tab.title)
        .font(.C1)
        .foregroundStyle(.text1)
        .lineLimit(1)

      Spacer(minLength: 8)

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
    .padding(.horizontal, 14)
    .frame(width: width, height: 33)
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
