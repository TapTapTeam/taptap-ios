//
//  SidebarSettingsButton.swift
//  TapTapMac
//

import SwiftUI

import DesignSystem

struct SidebarSettingsButton: View {
  let onSettings: () -> Void

  @State private var isHovered = false

  var body: some View {
    Button(action: onSettings) {
      Image(icon: MacIcon.setting)
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
        .frame(width: 32, height: 32)
        .background(
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(isHovered ? Color.n40 : Color.n0)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .strokeBorder(Color.divider1, lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
    .buttonStyle(.plain)
    .onHover { isHovered = $0 }
    .animation(SidebarHover.animation, value: isHovered)
    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 2)
  }
}
