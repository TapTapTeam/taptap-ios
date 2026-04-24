//
//  MacSidebarAssets.swift
//  MacHomeFeature
//

import SwiftUI

import DesignSystem

enum MacSidebarFigmaAsset {
  static let streetlights = URL(string: "https://www.figma.com/api/mcp/asset/e2f49374-962a-4a89-839b-9a65dc9b4e2d")!
  static let logo = URL(string: "https://www.figma.com/api/mcp/asset/2854f629-ba6c-40dd-99bb-5550f318070c")!
  static let sidebarToggle = URL(string: "https://www.figma.com/api/mcp/asset/03d8d5ba-29b7-490f-b6fc-e547c77bf340")!
  static let plusVector2 = URL(string: "https://www.figma.com/api/mcp/asset/4ac77856-c2e7-4ab8-8973-5be37d17d083")!
  static let plusVector3 = URL(string: "https://www.figma.com/api/mcp/asset/90080e26-b051-479c-8fb8-3e38d51957ac")!
  static let link = URL(string: "https://www.figma.com/api/mcp/asset/fac4149c-463d-47c4-9aba-2224c1017535")!
  static let settings = URL(string: "https://www.figma.com/api/mcp/asset/4d0544d6-a774-464a-952c-d79643021759")!
}

enum SidebarForeground {
  static let text1 = Color.text1
  static let caption2 = Color.caption2
  static let caption3 = Color.caption3
  static let iconGray = Color.iconGray
}

struct MacRemoteImage: View {
  let url: URL?
  var contentMode: ContentMode = .fit
  var showsPlaceholder: Bool = false

  var body: some View {
    AsyncImage(url: url) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: contentMode)
      case .failure:
        if showsPlaceholder {
          Color.n20
        } else {
          Color.clear
        }
      case .empty:
        if showsPlaceholder {
          Color.n20.opacity(0.6)
        } else {
          Color.clear
        }
      @unknown default:
        Color.clear
      }
    }
  }
}

struct SidebarToggleIcon: View {
  var isCollapsed: Bool

  var body: some View {
    ZStack {
      Image(systemName: "sidebar.leading")
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(SidebarForeground.iconGray)

      MacRemoteImage(url: MacSidebarFigmaAsset.sidebarToggle, showsPlaceholder: false)
        .scaleEffect(x: isCollapsed ? -1 : 1, y: 1)
        .frame(width: 24, height: 24)
    }
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
    ZStack {
      MacRemoteImage(url: MacSidebarFigmaAsset.plusVector2)
        .frame(width: 10, height: 10)
        .rotationEffect(.degrees(45))
      MacRemoteImage(url: MacSidebarFigmaAsset.plusVector3)
        .frame(width: 10, height: 10)
        .rotationEffect(.degrees(45))
    }
    .frame(width: 12, height: 12)
  }
}

struct SeeMoreButton: View {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 6, style: .continuous)
        .fill(Color.n30)
        .frame(width: 24, height: 24)

      HStack(spacing: 3.5) {
        Circle().fill(SidebarForeground.caption2).frame(width: 2, height: 2)
        Circle().fill(SidebarForeground.caption2).frame(width: 2, height: 2)
        Circle().fill(SidebarForeground.caption2).frame(width: 2, height: 2)
      }
    }
    .frame(width: 24, height: 24)
    .accessibilityLabel("더보기")
  }
}

