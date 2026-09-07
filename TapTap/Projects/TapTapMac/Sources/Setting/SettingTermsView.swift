//
//  SettingTermsView.swift
//  TapTapMac
//
//  Created by 여성일 on 7/15/26.
//

import AppKit
import SwiftUI
import DesignSystem

struct SettingTermsView: View {
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
        Text("서비스 이용약관")
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
          Text("제1조(목적)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
          Text("이 약관은 탭탭 TapTap(이하 '회사')이 제공하는 기사 요약 및 스크랩 서비스(이하 '서비스')의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          
          Text("제2조(정의)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("‘이용자’란 본 약관에 따라 회사가 제공하는 서비스를 이용하는 모든 자를 말합니다.\n본 서비스는 별도의 회원가입 또는 로그인 절차 없이 Safari 확장 기능 및 앱을 통해 이용할 수 있습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          
          Text("제3조(약관의 효력 및 변경)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("본 약관은 서비스 내에 게시함으로써 효력이 발생합니다.\n회사는 관련 법령을 위배하지 않는 범위 내에서 약관을 변경할 수 있으며, 변경 시 서비스 내에 공지합니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          
          Text("제4조(서비스의 제공 및 변경)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("회사는 연중무휴, 1일 24시간 서비스를 제공합니다. 단, 시스템 점검 등 불가피한 사유가 있는 경우 서비스 제공이 일시 중단될 수 있습니다.\n서비스의 내용은 회사의 정책에 따라 변경될 수 있습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          
          Text("제5조(개인정보보호)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("회사는 본 서비스 이용과 관련하여 최소한의 개인정보만을 수집·이용합니다.\n회사는 이용자의 개인정보를 별도로 저장하거나 로그인·회원정보와 연계하지 않습니다.\n기타 개인정보 관련 사항은 별도의 개인정보처리방침에 따릅니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          
          Text("제6조(저작권)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("서비스 내 제공되는 기사, 이미지, 요약 내용 등 모든콘텐츠의 저작권은 해당 원저작자 또는 정당한 권리자에게 귀속됩니다.\n이용자는 회사가 정한 범위 내에서만 이를 개인적, 비상업적 용도로 이용할 수 있으며 이를 위반하여 발생하는 문제에 대한 책임은 이용자 본인에게 있습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          
          Text("제7조(면책)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("회사는 천재지변 등 불가항력 사유로 인한 서비스 중단에 대해 책임을 지지 않습니다.\n회사는 이용자의 귀책사유로 인한 서비스 이용 장애에 대해 책임을 지지 않습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          
          Text("제8조(관할범원 및 준거법)")
            .font(.B1_SB)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("서비스와 관련된 분쟁은 대한민국 법을 적용하며, 관할법원은 민사소송법에 따릅니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
          
          Text("부칙")
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
          Text("본 약관은 2026년 7월 15일부터 시행합니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.B3_R_HLM)
            .foregroundStyle(.caption2)
            .padding(.top, 8)
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
