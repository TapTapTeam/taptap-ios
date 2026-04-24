//
//  SearchEmptyView.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import DesignSystem

public struct SearchQueryEmptyView: View {
  public init() {}
}

public extension SearchQueryEmptyView {
  var body: some View {
    VStack(spacing: 10) {
      Image(icon: "MacEmptySearchImage")
        .frame(width: 100, height: 100)
      
      Text("아직 검색 기록이 없어요")
        .font(.B1_M)
        .foregroundStyle(.caption3)
    }
    .frame(height: 141)
  }
}
