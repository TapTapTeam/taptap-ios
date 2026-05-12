//
//  LinkListEmptyView.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import SwiftUI
import DesignSystem

/// 링크가 하나도 없을 때 보여지는 뷰입니다.
struct LinkListEmptyView: View {
  var body: some View {
    VStack(spacing: 10) {
      DesignSystemAsset.emptyImage.swiftUIImage
        .resizable()
        .scaledToFit()
        .frame(width: 160, height: 160)
      
      Text("아직 저장한 링크가 없어요")
        .font(.B1_M)
        .foregroundStyle(Color.caption3)
        .padding(.bottom, 80)
   
      Button {
        print("새 링크 추가하기 버튼입니다")
      } label: {
        HStack {
          DesignSystemAsset.plus.swiftUIImage
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .foregroundStyle(.textw)
          Text("새 링크 추가하기")
            .font(.H4_SB)
            .foregroundStyle(.textw)
            .padding(.horizontal, 6)
            .padding(.vertical, 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
      }
      .frame(minHeight: 44)
      .background(.bgBtn)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .buttonStyle(.plain)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.bottom, 60)
  }
}

#Preview {
  LinkListEmptyView()
}
