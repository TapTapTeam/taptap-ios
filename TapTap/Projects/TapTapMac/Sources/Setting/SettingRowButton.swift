//
//  SettingRowButton.swift
//  TapTapMac
//
//  Created by 여성일 on 7/15/26.
//

import SwiftUI
import DesignSystem

enum SettingRowButtonType {
  case text(String)
  case image
}

struct SettingRowButton: View {
  let type: SettingRowButtonType
  let icon: String
  let title: String
  let action: () -> Void

  init(
    type: SettingRowButtonType = .image,
    icon: String,
    title: String,
    action: @escaping () -> Void = {}
  ) {
    self.type = type
    self.icon = icon
    self.title = title
    self.action = action
  }
}

extension SettingRowButton {
  var body: some View {
    Button(action: action) {
      HStack {
        Image(icon: icon)
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)

        Text(title)
          .font(.B1_M)
          .foregroundStyle(.text1)
          .padding(.horizontal, 8)

        Spacer()

        switch type {
        case let .text(value):
          Text(value)
            .font(.B1_M)
            .foregroundStyle(.caption1)

        case .image:
          Image(icon: MacIcon.chevron_right)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .padding(.trailing, -10)
        }
      }
      .frame(height: 52)
      .macHoverBackground(cornerRadius: 8, normal: .clear, hovered: .n30)
    }
    .buttonStyle(.plain)
  }
}
