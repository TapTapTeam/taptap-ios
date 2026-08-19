//
//  SettingOpensourceView.swift
//  TapTapMac
//
//  Created by 여성일 on 7/15/26.
//

import AppKit
import SwiftUI
import DesignSystem

struct SettingOpensourceView: View {
  let onClose: () -> Void
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Button(action: { dismiss() }) {
          Image(icon: MacIcon.chevron_left)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(.icon)
            .frame(width: 24, height: 24)
        }
        .buttonStyle(.plain)
        Text("사용된 오픈 소스")
          .font(.B1_SB)
          .foregroundStyle(.text1)
          .padding(.leading, 10)
        Spacer()
        Button(action: onClose) {
          Image(icon: MacIcon.close)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .padding(10)
            .contentShape(Rectangle())
        }
        .padding(.trailing, -8)
        .buttonStyle(.plain)
      }
      .frame(height: 40)
      
      VStack(spacing: 10) {
        SettingRowButton(icon: MacIcon.opensource, title: "Composable Architecture") {
          NSWorkspace.shared.open(URL(string: "https://github.com/pointfreeco/swift-composable-architecture")!)
        }
        SettingRowButton(icon: MacIcon.opensource, title: "Tuist") {
          NSWorkspace.shared.open(URL(string: "https://tuist.dev/ko")!)
        }
      }
      .padding(.top, 10)
      
      Spacer()
    }
    .padding(.top, 10)
    .padding(.horizontal, 20)
    .frame(maxWidth: 560, maxHeight: 600)
    .background(Color.background)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}
