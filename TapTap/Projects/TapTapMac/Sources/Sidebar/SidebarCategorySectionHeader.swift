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
          Gradient.Stop(color: .n0, location: 0.6),
          Gradient.Stop(color: .bgButtonGrad4, location: 1.0)
        ],
        startPoint: .top,
        endPoint: .bottom
      )
      .frame(maxWidth: .infinity)
      .frame(height: 56)
      // 좌우 가장자리가 블러로 흐려져 밑의 행이 비치지 않도록 사이드바 여백까지 넓힌다(사이드바 배경도 n0라 티 안 남).
      .padding(.horizontal, -12)
      .blur(radius: 6)
      // 블러는 위 가장자리도 흐리게 하므로 위쪽은 불투명 n0로 덮어 divider 바로 아래가 비치지 않게 한다.
      .overlay(alignment: .top) {
        Color.n0
          .frame(maxWidth: .infinity)
          .frame(height: 16)
      }

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
