//
//  SidebarSettingsButton.swift
//  MacHomeFeature
//

import SwiftUI

import DesignSystem

struct SidebarSettingsButton: View {
  let onSettings: () -> Void

  var body: some View {
    Button(action: onSettings) {
      MacRemoteImage(url: MacSidebarFigmaAsset.settings)
        .frame(width: 24, height: 24)
        .frame(width: 32, height: 32)
    }
    .buttonStyle(.plain)
    .background(
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color.n0)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .strokeBorder(Color.divider1, lineWidth: 1)
    )
    .shadow(color: .bgShadow3, radius: 8, x: 0, y: 0)
  }
}

