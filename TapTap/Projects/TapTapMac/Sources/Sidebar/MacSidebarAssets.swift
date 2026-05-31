//
//  MacSidebarAssets.swift
//  MacHomeFeature
//

import SwiftUI

import DesignSystem

enum MacSidebarAsset {
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
    HStack(spacing: -2) {
      MacSidebarAssetImage(asset: MacSidebarAsset.logoLeft)
        .frame(width: 20, height: 20)
      MacSidebarAssetImage(asset: MacSidebarAsset.logoRight)
        .frame(width: 20, height: 20)
    }
    .frame(width: 36, height: 36)
  }
}

struct SidebarToggleIcon: View {
  var isCollapsed: Bool

  var body: some View {
    Image(icon: isCollapsed ? Icon.sidebarOpen : Icon.sidebarClose)
      .resizable()
      .scaledToFit()
      .frame(width: 24, height: 24)
    .frame(width: 32, height: 32)
    .background(
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color.n0)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .strokeBorder(Color.divider1.opacity(0.6), lineWidth: 1)
    )
  }
}

struct SidebarPlusIcon: View {
  var body: some View {
    Image(icon: Icon.plusThin)
      .resizable()
      .scaledToFit()
      .frame(width: 24, height: 24)
  }
}

struct SeeMoreButton: View {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 6, style: .continuous)
        .fill(Color.n30)
        .frame(width: 24, height: 24)

      Image(icon: Icon.moreVertical)
        .resizable()
        .scaledToFit()
        .frame(width: 16, height: 16)
    }
    .frame(width: 24, height: 24)
    .accessibilityLabel("더보기")
  }
}
