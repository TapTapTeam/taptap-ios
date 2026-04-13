//
//  SearchRecentView.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import DesignSystem

public struct SearchRecentView: View {
  @Binding private var recentQuery: [String]
  private let onTap: (String) -> Void
  private let onDelete: (String) -> Void
  private let onClear: () -> Void
  
  public init(
    recentQuery: Binding<[String]>,
    onTap: @escaping (String) -> Void,
    onDelete: @escaping (String) -> Void,
    onClear: @escaping () -> Void
  ) {
    self._recentQuery = recentQuery
    self.onTap = onTap
    self.onDelete = onDelete
    self.onClear = onClear
  }
}

public extension SearchRecentView {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("최근 검색어")
          .font(.B2_M)
          .foregroundStyle(.caption2)
        Spacer()
        SearchDeleteButton(action: {
          onClear()
        })
      }
      
      ForEach(recentQuery, id: \.self) { item in
        Button {
          onTap(item)
        } label: {
          HStack(spacing: 12) {
            Image(icon: Icon.history)
              .renderingMode(.template)
              .foregroundStyle(.iconDisabled)
              .frame(width: 24, height: 24)
            
            Text(item)
              .font(.B1_M)
              .foregroundStyle(.text1)
          }
          .frame(height: 36)
        }
        .buttonStyle(.plain)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
