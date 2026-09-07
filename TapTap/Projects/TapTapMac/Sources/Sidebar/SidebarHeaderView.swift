//
//  SidebarHeaderView.swift
//  TapTapMac
//

import SwiftUI

import DesignSystem

struct SidebarHeaderView: View {
  let isCollapsed: Bool
  let onToggleSidebar: () -> Void

  var body: some View {
    Group {
      if isCollapsed {
        HStack {
          Spacer()
          Button(action: onToggleSidebar) {
            SidebarToggleIcon(isCollapsed: isCollapsed)
          }
          .buttonStyle(.plain)
        }
        .padding(.top, 35)
      } else {
        HStack(spacing: 12) {
          HStack(spacing: 12) {
            MacSidebarLogoIcon()
              .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text("탭탭")
              .font(.H4_M)
              .foregroundStyle(SidebarForeground.text1)
          }
          .offset(y: 16)

          Spacer(minLength: 0)

          Button(action: onToggleSidebar) {
            SidebarToggleIcon(isCollapsed: isCollapsed)
          }
          .buttonStyle(.plain)
          .offset(y: -10)
        }
        .frame(height: 48)
        .padding(.top, 42)
      }
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }
}

#Preview {
  SidebarHeaderView(isCollapsed: false) {
    
  }
}
