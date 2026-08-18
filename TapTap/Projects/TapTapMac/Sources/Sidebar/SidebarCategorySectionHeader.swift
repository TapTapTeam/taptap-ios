//
//  SidebarCategorySectionHeader.swift
//  TapTapMac
//

import SwiftUI

import DesignSystem

struct SidebarCategorySectionHeader: View {
  let onAddCategory: () -> Void

  var body: some View {
    ZStack(alignment: .top) {
      // 스티키 "카테고리" 헤더 뒤 스크림. 위쪽은 완전 흰색이라 스크롤되는 행이
      // 헤더에 닿기 전에 사라지고, 아래로 투명해져 그 밑 행은 정상적으로 보인다.
      LinearGradient(
        stops: [
          Gradient.Stop(color: .n0, location: 0.0),
          Gradient.Stop(color: .n0, location: 0.75),
          Gradient.Stop(color: .bgButtonGrad4, location: 1.0)
        ],
        startPoint: .top,
        endPoint: .bottom
      )
      .frame(maxWidth: .infinity)
      .frame(height: 48)

      HStack {
        Text("카테고리")
          .font(.B2_M)
          .foregroundStyle(SidebarForeground.caption3)
        Spacer(minLength: 0)
        SidebarPlusButton(accessibilityLabel: "카테고리 추가", action: onAddCategory)
      }
      .padding(.leading, 4)
      .padding(.top, 7)
    }
    .frame(height: 40, alignment: .top)
  }
}
