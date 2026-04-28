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
  private let action: () -> Void

  public init(
    selectedCategory: String = "전체",
    action: @escaping () -> Void
  ) {
    self.selectedCategory = selectedCategory
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
        
        Image(icon: "small-chevron-up")
          .frame(width: 20, height: 20)
      }
    }
    .buttonStyle(.plain)
    .frame(height: 32)
    .padding(.horizontal, 8)
    .background(
      Capsule()
        .strokeBorder(Color.divider2, lineWidth: 1)
    )
    .backgroundStyle(Color.background)
  }
}

  #Preview {
    SearchCategoryButton(action: {})
  }
