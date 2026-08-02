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
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Spacer()
        Button(action: onToggleSidebar) {
          SidebarToggleIcon(isCollapsed: isCollapsed)
        }
        .buttonStyle(.plain)
      }

      if !isCollapsed {
        HStack(spacing: 12) {
          MacSidebarLogoIcon()
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

          Text("탭탭")
            .font(.H4_M)
            .foregroundStyle(SidebarForeground.text1)
        }
        .padding(.top, 10)
      }
    }
    .padding(.top, 35)
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }
}

#Preview {
  SidebarHeaderView(isCollapsed: false) {
    
  }
}
