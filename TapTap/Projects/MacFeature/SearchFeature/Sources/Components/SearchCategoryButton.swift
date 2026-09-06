//
//  SearchCategoryButton.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/27/26.
//

import SwiftUI
import DesignSystem

public struct SearchCategoryButton: View {
  private let selectedCategory: String
  private let isExpanded: Bool
  private let action: () -> Void
  
  public init(
    selectedCategory: String = "전체",
    isExpanded: Bool = false,
    action: @escaping () -> Void
  ) {
    self.selectedCategory = selectedCategory
    self.isExpanded = isExpanded
    self.action = action
  }
}

public extension SearchCategoryButton {
  var body: some View {
    Button(action: action) {
      HStack(spacing: 0) {
        Text(selectedCategory)
          .font(.B2_M)
          .foregroundStyle(.caption1)
          .padding(.horizontal, 8)
        
        Image(icon: isExpanded ? "small-chevron-up" : "small-chevron-down")
          .frame(width: 20, height: 20)
      }
      .frame(height: 32)
      .padding(.horizontal, 8)
      .macHoverBackground(Capsule(), normal: .clear, hovered: .n30)
      .background(
        Capsule()
          .strokeBorder(Color.divider2, lineWidth: 1)
      )
      .backgroundStyle(Color.background)
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  SearchCategoryButton(action: {})
}
