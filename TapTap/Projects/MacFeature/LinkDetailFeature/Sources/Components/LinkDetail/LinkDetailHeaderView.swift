//
//  LinkDetailHeaderView.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

import SwiftUI

import DesignSystem

/// 링크 상세 상단의 작성일과 제목을 표시합니다.
struct LinkDetailHeaderView: View {
  let date: Date
  let title: String

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text(DateFormatter.articleDateFormatter.string(from: date))
        .font(.B2_M)
        .foregroundStyle(.caption2)
        .frame(maxWidth: .infinity, alignment: .leading)

      Text(title)
        .font(.H2)
        .foregroundStyle(.text1)
        .lineLimit(nil)
        .multilineTextAlignment(.leading)
    }
  }
}
