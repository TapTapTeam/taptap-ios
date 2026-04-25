//
//  SidebarMyLinksView.swift
//  MacHomeFeature
//

import SwiftUI

import DesignSystem

struct SidebarMyLinksView: View {
  let totalLinkCount: Int
  let isSeeAllSelected: Bool
  let onAddLink: () -> Void
  let onSeeAllLinks: () -> Void

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
        Button(action: onAddLink) {
          SidebarPlusIcon()
            .frame(width: 32, height: 32)
            .background(
              RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.n20)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("링크 추가")
      }
      .padding(.leading, 4)

      Button(action: onSeeAllLinks) {
        HStack(spacing: 10) {
          MacRemoteImage(url: MacSidebarFigmaAsset.link)
            .frame(width: 24, height: 24)
          Text("모두 보기")
            .font(.B1_SB)
            .foregroundStyle(SidebarForeground.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text("\(totalLinkCount)개")
            .font(.B2_M)
            .foregroundStyle(Color.bl8)
            .padding(.horizontal, 6)
        }
        .padding(.leading, 12)
        .padding(.trailing, 6)
        .frame(height: 36)
        .background(
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(isSeeAllSelected ? Color.bl1 : Color.clear)
        )
      }
      .buttonStyle(.plain)
      .padding(.vertical, 6)
    }
  }
}

