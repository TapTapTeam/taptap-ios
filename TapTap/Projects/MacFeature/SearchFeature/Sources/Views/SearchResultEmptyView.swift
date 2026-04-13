//
//  SearchResultEmptyView.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import DesignSystem

public struct SearchResultEmptyView: View {
  private let query: String

  public init(query: String) {
    self.query = query
  }
}

public extension SearchResultEmptyView {
  var body: some View {
    VStack(spacing: 10) {
      Image(icon: "MacEmptySearchResultImage")
        .frame(width: 160, height: 160)
      
      Text("'\(query)' 관련 링크를 찾을 수 없어요\n다른 단어로 검색해보세요")
        .font(.B1_M)
        .foregroundStyle(.caption3)
        .lineLimit(2)
        .multilineTextAlignment(.center)
    }
  }
}
