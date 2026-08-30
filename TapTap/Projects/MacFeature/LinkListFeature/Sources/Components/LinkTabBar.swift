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

  @State private var hoveredTabID: String?

  var body: some View {
    GeometryReader { geometry in
      let plusButtonWidth: CGFloat = 36
      let tabsAreaWidth = max(geometry.size.width - plusButtonWidth, 0)
      let tabWidth = calculatedTabWidth(
        totalWidth: geometry.size.width,
        plusButtonWidth: plusButtonWidth
      )

      HStack(spacing: 0) {
        // 탭이 영역보다 넓어지면 잘라내는 대신 가로로 스크롤한다.
        // 잘라내기만 하면 화면 밖으로 밀린 탭은 선택도 닫기도 할 수 없다.
        ScrollViewReader { proxy in
          ScrollView(.horizontal) {
            HStack(spacing: 0) {
              ForEach(tabs) { tab in
                tabItem(tab, width: tabWidth)
                  .id(tab.id)
              }
            }
          }
          .scrollIndicators(.never)
          .frame(width: tabsAreaWidth, alignment: .leading)
          .onChange(of: selectedTabID) { _, newValue in
            // 새로 연 탭이 스크롤 밖에 생기면 보이지 않으므로 따라간다.
            guard let newValue else { return }
            withAnimation(.easeInOut(duration: 0.15)) {
              proxy.scrollTo(newValue, anchor: .center)
            }
          }
        }

        plusButton(width: plusButtonWidth)
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
  var minTabWidth: CGFloat { 64 }
  var allLinksIconThreshold: CGFloat { 100 }

  func calculatedTabWidth(totalWidth: CGFloat, plusButtonWidth: CGFloat) -> CGFloat {
    guard !tabs.isEmpty else { return 0 }

    let availableTabsWidth = max(totalWidth - plusButtonWidth, 0)
    return max(availableTabsWidth / CGFloat(tabs.count), minTabWidth)
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
    let showsAllLinksIcon = tab.context == .allLinks && width < allLinksIconThreshold
    // 선택된 탭만 닫을 수 있으면 배경 탭을 닫으려고 먼저 선택해야 한다.
    // 탭이 하나뿐이면 탭바가 사라지지 않도록 닫기 버튼을 보여주지 않는다.
    let showsCloseButton = tabs.count > 1 && (isSelected || hoveredTabID == tab.id)

    return HStack(spacing: 10) {
      if showsAllLinksIcon {
        DesignSystemAsset.macLogo.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .saturation(0)
          .frame(width: 16, height: 16)
      } else {
        Text(tab.title)
          .font(.C1)
          .foregroundStyle(.text1)
          .lineLimit(1)
      }

      Spacer(minLength: 8)

      if showsCloseButton {
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
    .onHover { isHovering in
      if isHovering {
        hoveredTabID = tab.id
      } else if hoveredTabID == tab.id {
        hoveredTabID = nil
      }
    }
    .onTapGesture {
      onSelect(tab.id)
    }
  }
}
