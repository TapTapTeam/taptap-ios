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
  var radius: CGFloat = 8

  func makeNSView(context: Context) -> BlurView {
    let view = BlurView()
    view.wantsLayer = true
    view.layerUsesCoreImageFilters = true
    view.radius = radius
    return view
  }

  func updateNSView(_ nsView: BlurView, context: Context) {
    nsView.radius = radius
  }

  final class BlurView: NSView {
    var radius: CGFloat = 4 {
      didSet { applyFilters() }
    }

    override func hitTest(_ point: NSPoint) -> NSView? { nil }

    override func viewDidMoveToWindow() {
      super.viewDidMoveToWindow()
      applyFilters()
    }

    override func viewDidChangeBackingProperties() {
      super.viewDidChangeBackingProperties()
      applyFilters()
    }

    private func applyFilters() {
      guard
        let clamp = CIFilter(name: "CIAffineClamp"),
        let blur = CIFilter(name: "CIGaussianBlur")
      else { return }
      let scale = window?.backingScaleFactor ?? 2
      clamp.setValue(CGAffineTransform.identity, forKey: "inputTransform")
      blur.setValue(radius * scale, forKey: kCIInputRadiusKey)
      layer?.backgroundFilters = [clamp, blur]
    }
  }
}

struct SidebarToggleIcon: View {
  var isCollapsed: Bool
  /// 사이드바 밖(콘텐츠 위)에 떠 있을 때 켠다. 옆의 네비게이션 버튼과 같은 배경·그림자를 쓴다.
  var isFloating: Bool = false

  @State private var isHovered = false

  private var cornerRadius: CGFloat { isFloating ? 12 : 8 }

  private var backgroundColor: Color {
    if isFloating { return isHovered ? Color.n40 : Color.n0 }
    return isHovered ? Color.n20 : Color.clear
  }

  var body: some View {
    Image(icon: isCollapsed ? MacIcon.sidebarOpen : MacIcon.sidebarClose)
      .resizable()
      .scaledToFit()
      .frame(width: 24, height: 24)
      .frame(width: 40, height: 40)
      .background(
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .fill(backgroundColor)
      )
      .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
      .shadow(color: isFloating ? Color.bgShadow2 : .clear, radius: 3, x: 0, y: 2)
      .shadow(color: isFloating ? Color.bgShadow1 : .clear, radius: 2, x: 0, y: 2)
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
  @State private var isHovered = false

  private static let selectedBackground = Color(red: 218 / 255, green: 215 / 255, blue: 254 / 255)
  private static let selectedHoverBackground = Color(red: 196 / 255, green: 191 / 255, blue: 253 / 255)

  private var backgroundColor: Color {
    if colorScheme == .dark { return isHovered ? Color.n50 : Color.bgDimSelect }
    if isSelectedRow { return isHovered ? Self.selectedHoverBackground : Self.selectedBackground }
    return isHovered ? Color.n40 : Color.n30
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
    .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    .onHover { isHovered = $0 }
    .animation(SidebarHover.animation, value: isHovered)
    .accessibilityLabel("더보기")
  }
}
