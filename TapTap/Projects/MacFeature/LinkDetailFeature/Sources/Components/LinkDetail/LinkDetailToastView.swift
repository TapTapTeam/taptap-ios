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

  var body: some View {
    Text(message)
      .font(.C1)
      .foregroundStyle(.text1)
      .padding(.horizontal, 14)
      .padding(.vertical, 9)
      .background(Color.n0)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .shadow(color: .bgShadow3, radius: 8, x: 0, y: 0)
      .padding(.top, 12)
      .transition(.move(edge: .top).combined(with: .opacity))
  }
}
