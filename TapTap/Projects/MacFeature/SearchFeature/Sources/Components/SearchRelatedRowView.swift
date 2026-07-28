//
//  SearchRelatedRowView.swift
//  MacSearchFeature
//
//  Created by 여성일 on 5/11/26.
//

import SwiftUI
import DesignSystem

public struct SearchRelatedRowView: View {
  private let keyword: String
  private let query: String
  private let onTap: (String) -> Void
  
  @State private var isHovered = false
  
  public init(
    keyword: String,
    query: String,
    onTap: @escaping (String) -> Void
  ) {
    self.keyword = keyword
    self.query = query
    self.onTap = onTap
  }
  
  private var backgroundColor: Color {
    isHovered ? .n20 : .clear
  }
}

public extension SearchRelatedRowView {
  var body: some View {
    Button {
      onTap(keyword)
    } label: {
      SearchRelatedKeywordText(
        fullText: keyword,
        query: query
      )
      .padding(.horizontal, 20)
      .frame(height: 36)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .buttonStyle(.plain)
    .background(backgroundColor)
    .onHover { isHovered = $0 }
  }
}
