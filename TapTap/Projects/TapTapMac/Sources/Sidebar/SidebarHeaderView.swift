//
//  SidebarHeaderView.swift
//  MacHomeFeature
//

import SwiftUI

import DesignSystem

struct SidebarHeaderView: View {
  let isCollapsed: Bool
  let onToggleSidebar: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 30) {
      if !isCollapsed {
        MacSidebarAssetImage(asset: MacSidebarAsset.wordmark)
          .frame(width: 52, height: 12)
      }

      HStack(spacing: 12) {
        if !isCollapsed {
          HStack(spacing: 12) {
            MacSidebarLogoIcon()
              .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text("탭탭")
              .font(.H4_M)
              .foregroundStyle(SidebarForeground.text1)
          }
        }

        Spacer(minLength: 0)

        Button(action: onToggleSidebar) {
          SidebarToggleIcon(isCollapsed: isCollapsed)
        }
        .buttonStyle(.plain)
      }
      .padding(.bottom, isCollapsed ? 0 : 8)
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }
}
