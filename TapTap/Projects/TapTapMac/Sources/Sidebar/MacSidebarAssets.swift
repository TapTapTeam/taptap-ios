//
//  MacSidebarAssets.swift
//  TapTapMac
//

import SwiftUI

import DesignSystem

enum MacSidebarAsset {
  static let logo = DesignSystemAsset.macLogo
  static let wordmark = DesignSystemAsset.logo
  static let logoLeft = DesignSystemAsset.logoLeft
  static let logoRight = DesignSystemAsset.logoRight
}

enum SidebarForeground {
  static let text1 = Color.text1
  static let caption2 = Color.caption2
  static let caption3 = Color.caption3
  static let iconGray = Color.iconGray
}

struct MacSidebarAssetImage: View {
  let asset: DesignSystemImages
  var contentMode: ContentMode = .fit

  var body: some View {
    asset.swiftUIImage
      .resizable()
      .aspectRatio(contentMode: contentMode)
  }
}

struct MacSidebarLogoIcon: View {
  var body: some View {
    Image(icon: MacIcon.logo)
      .resizable()
      .scaledToFit()
      .frame(width: 36, height: 36)
  }
}

/// 사이드바 공통 호버 애니메이션. DesignSystem macOS 버튼(`MacArrowButton` 등)과 동일한 곡선·길이.
enum SidebarHover {
  static let animation: Animation = .easeOut(duration: 0.12)
}

/// 사이드바 접기/펼치기 아이콘. 기본은 아이콘만, 호버 시 n20 라운드 배경.
struct SidebarToggleIcon: View {
  var isCollapsed: Bool

  @State private var isHovered = false

  var body: some View {
    Image(icon: isCollapsed ? MacIcon.sidebarOpen : MacIcon.sidebarClose)
      .resizable()
      .scaledToFit()
      .frame(width: 24, height: 24)
      .frame(width: 40, height: 40)
      .background(
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .fill(isHovered ? Color.n20 : Color.clear)
      )
      .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
      .onHover { isHovered = $0 }
      .animation(SidebarHover.animation, value: isHovered)
  }
}

/// "내 링크"·"카테고리" 섹션 헤더의 32pt + 버튼. 호버 시 n20 → n30.
struct SidebarPlusButton: View {
  let accessibilityLabel: String
  let action: () -> Void

  @State private var isHovered = false

  var body: some View {
    Button(action: action) {
      Image(icon: MacIcon.plus)
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
        .frame(width: 32, height: 32)
        .background(
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(isHovered ? Color.n30 : Color.n20)
        )
        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
    .buttonStyle(.plain)
    .onHover { isHovered = $0 }
    .animation(SidebarHover.animation, value: isHovered)
    .accessibilityLabel(accessibilityLabel)
  }
}

struct SeeMoreButton: View {
  var isSelectedRow: Bool = false

  private static let selectedBackground = Color(red: 218 / 255, green: 215 / 255, blue: 254 / 255)

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 6, style: .continuous)
        .fill(isSelectedRow ? Self.selectedBackground : Color.n30)
        .frame(width: 24, height: 24)

      Image(icon: MacIcon.more)
        .resizable()
        .scaledToFit()
        .frame(width: 16, height: 16)
    }
    .frame(width: 24, height: 24)
    .accessibilityLabel("더보기")
  }
}
