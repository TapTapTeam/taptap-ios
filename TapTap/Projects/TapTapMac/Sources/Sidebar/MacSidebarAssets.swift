//
//  MacSidebarAssets.swift
//  TapTapMac
//

import AppKit
import CoreImage
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

enum SidebarHover {
  static let animation: Animation = .easeOut(duration: 0.12)
}

struct SidebarBackdropBlur: NSViewRepresentable {
  var radius: CGFloat = 4

  func makeNSView(context: Context) -> NSView {
    let view = PassthroughView()
    view.wantsLayer = true
    view.layerUsesCoreImageFilters = true
    return view
  }

  func updateNSView(_ nsView: NSView, context: Context) {
    guard
      let clamp = CIFilter(name: "CIAffineClamp"),
      let blur = CIFilter(name: "CIGaussianBlur")
    else { return }
    clamp.setValue(CGAffineTransform.identity, forKey: "inputTransform")
    blur.setValue(radius, forKey: kCIInputRadiusKey)
    nsView.layer?.backgroundFilters = [clamp, blur]
  }

  private final class PassthroughView: NSView {
    override func hitTest(_ point: NSPoint) -> NSView? { nil }
  }
}

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

  @Environment(\.colorScheme) private var colorScheme

  private static let selectedBackground = Color(red: 218 / 255, green: 215 / 255, blue: 254 / 255)

  private var backgroundColor: Color {
    if colorScheme == .dark { return Color.bgDimSelect }
    return isSelectedRow ? Self.selectedBackground : Color.n30
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 6, style: .continuous)
        .fill(backgroundColor)
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
