//
//  SidebarCategorySectionHeader.swift
//  MacHomeFeature
//

import SwiftUI

import DesignSystem

struct SidebarCategorySectionHeader: View {
  let onAddCategory: () -> Void

  var body: some View {
    ZStack(alignment: .top) {
      HStack {
        Spacer()
        LinearGradient(
          colors: [Color.bgButtonGrad4.opacity(0), Color.n0.opacity(0.25)],
          startPoint: .bottom,
          endPoint: .top
        )
        .frame(width: 240, height: 48)
        .rotationEffect(.degrees(180))
        Spacer()
      }
      .offset(y: -6)

      HStack {
        Text("카테고리")
          .font(.B2_M)
          .foregroundStyle(SidebarForeground.caption3)
        Spacer(minLength: 0)
        Button(action: onAddCategory) {
          SidebarPlusIcon()
            .frame(width: 32, height: 32)
            .background(
              RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.n20)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("카테고리 추가")
      }
      .padding(.leading, 4)
      .padding(.top, 7)
    }
    .frame(height: 40)
  }
}

