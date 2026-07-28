//
//  LinkDetailToastView.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

import SwiftUI

import DesignSystem

/// 링크 상세 화면 상단에 잠시 표시되는 토스트 메시지입니다.
struct LinkDetailToastView: View {
  let message: String
  let onClose: () -> Void

  var body: some View {
    HStack(spacing: 16) {
      Text(message)
        .font(.B1_SB)
        .foregroundStyle(.text1)

      Spacer(minLength: 0)

      MacToastCloseButton {
        onClose()
      }
    }
    .padding(.leading, 28)
    .padding(.trailing, 16)
    .frame(maxWidth: 560)
    .frame(height: 60)
    .background(Color.bl1)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .overlay {
      RoundedRectangle(cornerRadius: 16)
        .strokeBorder(Color.bl6, lineWidth: 2)
    }
    .shadow(color: .bgShadow3, radius: 8, x: 0, y: 2)
    .transition(.move(edge: .top).combined(with: .opacity))
  }
}
