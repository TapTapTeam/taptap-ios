//
//  SidebarMyLinksView.swift
//  TapTapMac
//

import SwiftUI

import DesignSystem

struct SidebarMyLinksView: View {
  let totalLinkCount: Int
  let isSeeAllSelected: Bool
  let onAddLink: () -> Void
  let onSeeAllLinks: () -> Void

  @State private var isSeeAllHovered = false

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Rectangle()
        .fill(Color.n40.opacity(0.24))
        .frame(height: 1)

      HStack {
        Text("내 링크")
          .font(.B2_M)
          .foregroundStyle(SidebarForeground.caption3)
        Spacer(minLength: 0)
        SidebarPlusButton(accessibilityLabel: "링크 추가", action: onAddLink)
      }
      .padding(.leading, 4)

      Button(action: onSeeAllLinks) {
        HStack(spacing: 10) {
          Image(icon: isSeeAllSelected ? MacIcon.linkActive : MacIcon.linkInactive)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
          Text("모두 보기")
            .font(.B1_SB)
            .foregroundStyle(SidebarForeground.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text("\(totalLinkCount)개")
            .font(.B2_M)
            .foregroundStyle(isSeeAllSelected ? Color.bl8 : Color.caption2)
            .padding(.horizontal, 6)
        }
        .padding(.leading, 12)
        .padding(.trailing, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 36)
        .background(
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(isSeeAllSelected ? Color.bl1 : (isSeeAllHovered ? Color.n20 : Color.clear))
        )
        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
      }
      .buttonStyle(.plain)
      .onHover { isSeeAllHovered = $0 }
      .animation(SidebarHover.animation, value: isSeeAllHovered)
      .padding(.vertical, 6)
    }
  }
}
