//
//  HighlightEmptyView.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 6/17/26.
//

import SwiftUI

import DesignSystem

struct HighlightEmptyView: View {
  let onOpenOriginalLink: () -> Void

  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      DesignSystemAsset.emptyImage.swiftUIImage
        .resizable()
        .scaledToFit()
        .frame(width: 160, height: 160)
      
      Text("나의 요약본이 존재하지 않아요!")
        .font(.B1_SB)
        .foregroundStyle(.caption1)
        .frame(maxWidth: .infinity)
      
      Text("원문을 읽고 중요한 부분에 하이라이트와 메모를 남겨보세요")
        .font(.B1_M)
        .foregroundStyle(.caption3)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)

      Button(action: onOpenOriginalLink) {
        HStack(spacing: 8) {
          Image(icon: Icon.linkMac)
            .resizable()
            .renderingMode(.template)
            .frame(width: 20, height: 20)

          Text("링크 원문보기")
            .font(.H4_SB)
        }
        .foregroundStyle(.textw)
        .padding(.horizontal, 18)
        .frame(height: 44)
        .background(.bgBtn)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .buttonStyle(.plain)
      .padding(.top, 70)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 160)
  }
}

#Preview {
  HighlightEmptyView {}
    .frame(width: 600, height: 500)
}
