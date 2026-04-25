//
//  SearchRelatedView.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import DesignSystem

public struct SearchRelatedView: View {
  private let keywords: [String]
  private let query: String
  private let onTap: (String) -> Void
  
  public init(
    keywords: [String],
    query: String,
    onTap: @escaping (String) -> Void
  ) {
    self.keywords = keywords
    self.query = query
    self.onTap = onTap
  }
}

public extension SearchRelatedView {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      ForEach(keywords, id: \.self) { keyword in
        Button {
          onTap(keyword)
        } label: {
          SearchRelatedKeywordText(
            fullText: keyword,
            query: query
          )
        }
        .buttonStyle(.plain)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
