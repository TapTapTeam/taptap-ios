//
//  SettingAlertView.swift
//  TapTapMac
//
//  Created by 여성일 on 7/15/26.
//

import SwiftUI
import DesignSystem

enum SettingDestination: Hashable {
  case privacy
  case terms
}

struct SettingAlertView: View {
  let onClose: () -> Void
  @State private var path = NavigationPath()

  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        HStack {
          Text("설정")
            .font(.B1_SB)
            .foregroundStyle(.black)
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

        VStack(spacing: 20) {
          SettingRowButton(type: .text("1.1.0"), icon: MacIcon.info, title: "앱 버전")

          SettingRowButton(icon: MacIcon.shield, title: "개인정보 처리방침") {
            path.append(SettingDestination.privacy)
          }

          SettingRowButton(icon: MacIcon.file, title: "서비스 이용약관") {
            path.append(SettingDestination.terms)
          }

          SettingRowButton(icon: MacIcon.opensource, title: "사용된 오픈 소스") {
            print("오픈소스")
          }

          SettingRowButton(icon: MacIcon.heart, title: "TapTap팀") {
            print("탭탭")
          }
        }
        .padding(.top, 10)

        Spacer()
      }
      .padding(.top, 10)
      .padding(.horizontal, 20)
      .navigationDestination(for: SettingDestination.self) { destination in
        switch destination {
        case .privacy:
          SettingPrivacyView(onClose: onClose)
        case .terms:
          SettingTermsView(onClose: onClose)
        }
      }
    }
    .toolbar(.hidden)
    .frame(maxWidth: 560, maxHeight: 600)
    .background(Color.background)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}
