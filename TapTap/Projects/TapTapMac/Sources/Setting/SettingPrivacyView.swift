//
//  SettingPrivacyView.swift
//  TapTapMac
//
//  Created by 여성일 on 7/15/26.
//

import AppKit
import SwiftUI
import DesignSystem

struct SettingPrivacyView: View {
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
            .macHoverBackground(cornerRadius: 6, normal: .clear, hovered: .n30)
        }
        .buttonStyle(.plain)
        Text("개인정보 처리방침")
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
            .macHoverBackground(cornerRadius: 8, normal: .clear, hovered: .n30)
        }
        .padding(.trailing, -8)
        .buttonStyle(.plain)
      }
      .frame(height: 40)
      
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          Text("2026년 07월 15일 마지막으로 업데이트 됨.")
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text("개요")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("탭탭 TapTap(이하 '회사')은 이용자의 개인정보를 소중히 생각하며, 관련 법령을 준수합니다. 「개인정보 보호법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」 등 관련 법령에 따라 이용자의 개인정보를 보호하고 관련한 고충을 신속하고 원활하게 처리할 수 있도록 다음과 같이 개인정보처리방침을 수립·공개합니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          Text("회사는 본 앱에서 이용자의 개인정보를 수집하거나 저장, 처리하지 않습니다. 다만, 서비스 운영상 불가피하게 수집될 수 있는 최소한의 정보는 아래와 같이 처리합니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 32)
          
          Text("제1조(개인정보의 수집 및 이용)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("회사는 본 애플리케이션(이하 ‘앱’)을 통해 이용자의 개인정보를 직접적으로 수집하지 않습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          Text("1. 서비스 이용 과정에서 자동 수집되는 정보")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 32)
          Text("서비스 품질 향상, 오류 분석, 통계 분석 등을 위하여 앱 이용 과정에서 자동으로 생성·수집되는 정보(기기 정보, 운영체제 버전, 이용 기록 등)가 있을 수 있습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 2)
            .padding(.leading, 11)
          Text("2. 기사 요약 및 스크랩 기능 이용 시")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 32)
          Text("이용자가 저장한 기사 링크, 제목, 요약 메모 등은 이용자 기기 내 로컬 저장소에 보관되며, 회사는 이를 수집하지 않습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 2)
            .padding(.leading, 11)
          Text("회사는 이용자의 위치정보를 수집하거나 이용하지 않습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 32)
          
          Text("제2조(자동 수집 정보 및 쿠키)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("회사는 앱의 운영 과정에서 자동으로 생성되는 정보(기기명, OS 버전, IP 주소, 접속 기록, 오류 로그 등)만을 수집할 수 있으며, 이용자가 직접 개인정보를 입력하거나 제공해야 하는 경우는 없습니다. 쿠키는 별도로 사용하지 않습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          
          Text("제3조(개인정보의 제3자 제공 및 위탁)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("회사는 이용자의 동의 없이 개인정보를 제3자에게 제공하지 않습니다. 단, 법령에 특별한 규정이 있는 경우 또는 수사기관의 요청 등 관련 법령에 따라 제공이 필요한 경우에는 예외로 합니다.\n또한, 앱의 서비스 개선 및 오류 분석을 위해 Firebase Crashlytics, Amplitude 등 외부 서비스가 사용될 수 있으며, 이들 서비스는 각자의 개인정보처리방침에 따라 정보를 처리할 수 있습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          Button {
            NSWorkspace.shared.open(URL(string: "https://firebase.google.com/support/privacy")!)
          } label: {
            HStack(spacing: 4) {
              Text("·")
                .font(.B3_R_HLM)
                .foregroundStyle(.caption2)
              Text("Firebase Crashlytics 개인정보처리방침")
                .underline()
                .font(.B3_R_HLM)
                .foregroundStyle(.caption2)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .buttonStyle(.plain)
          Button {
            NSWorkspace.shared.open(URL(string: "https://amplitude.com/privacy")!)
          } label: {
            HStack(spacing: 4) {
              Text("·")
                .font(.B3_R_HLM)
                .foregroundStyle(.caption2)
              Text("Amplitude 개인정보처리방침")
                .underline()
                .font(.B3_R_HLM)
                .foregroundStyle(.caption2)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .buttonStyle(.plain)
          
          Text("제4조(개인정보 보호책임자)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("이용자의 개인정보 보호와 관련된 문의, 불만처리, 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정합니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          HStack(spacing: 4) {
            Text("·")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
            Text("개인정보 보호책임자 : TapTap")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          HStack(spacing: 4) {
            Text("·")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
            Text("이메일 :")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
            Button {
              
            } label: {
              Text("taptap.contacts@gmail.com")
                .font(.B3_R_HLM)
                .foregroundStyle(.caption2)
                .underline()
            }
            .buttonStyle(.plain)
            .tint(.caption2)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          Text("회사는 수집된 정보를 이용 목적 달성 시 또는 이용자의 요청 시 지체 없이 파기하며, 관련 법령에 따라 보존이 필요한 경우에는 해당 기간 동안 안전하게 보관 후 파기합니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 2)
          
          Text("제5조(권익침해 구제방법)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("이용자는 개인정보와 관련된 문의, 신고, 상담이 필요할 경우 아래 기관에 문의할 수 있습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          HStack(spacing: 0) {
            Text("개인정보침해신고센터: 국번없이 118 (")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
            Button {
              NSWorkspace.shared.open(URL(string: "https://privacy.kisa.or.kr")!)
            } label: {
              Text("privacy.kisa.or.kr")
                .font(.B3_R_HLM)
                .foregroundStyle(.caption2)
                .underline()
            }
            .buttonStyle(.plain)
            Text(")")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
          }
          HStack(spacing: 0) {
            Text("개인정보분쟁조정위원회: 1833-6972 (")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
            Button {
              NSWorkspace.shared.open(URL(string: "https://www.kopico.go.kr")!)
            } label: {
              Text("www.kopico.go.kr")
                .font(.B3_R_HLM)
                .foregroundStyle(.caption2)
                .underline()
            }
            .buttonStyle(.plain)
            .tint(.caption2)
            Text(")")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
          }
          HStack(spacing: 0) {
            Text("대검찰청: 1301 (")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
            Button {
              NSWorkspace.shared.open(URL(string: "https://www.spo.go.kr")!)
            } label: {
              Text("www.spo.go.kr")
                .font(.B3_R_HLM)
                .foregroundStyle(.caption2)
                .underline()
            }
            .buttonStyle(.plain)
            .tint(.caption2)
            Text(")")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
          }
          HStack(spacing: 0) {
            Text("경찰청: 182 (")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
            Button {
              NSWorkspace.shared.open(URL(string: "https://ecrm.cyber.go.kr")!)
            } label: {
              Text("ecrm.cyber.go.kr")
                .font(.B3_R_HLM)
                .foregroundStyle(.caption2)
                .underline()
            }
            .buttonStyle(.plain)
            Text(")")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption2)
          }
          
          Text("제6조(방침의 변경)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("본 방침은 관련 법령 및 회사 정책에 따라 변경될 수 있으며, 변경 시 앱 내에 공지합니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          Text("부칙")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 2)
          Text("본 약관은 2026년 7월 15일부터 시행합니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 2)
        }
        .padding(.bottom, 20)
      }
      .padding(.top, 18)
    }
    .padding(.top, 10)
    .padding(.horizontal, 20)
    .frame(maxWidth: 560, maxHeight: 600)
    .background(Color.background)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}
