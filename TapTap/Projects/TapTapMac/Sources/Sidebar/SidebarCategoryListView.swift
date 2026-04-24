//
//  SidebarCategoryListView.swift
//  MacHomeFeature
//

import SwiftUI

import Core
import DesignSystem

struct SidebarCategoryListView: View {
  let categories: [CategoryItem]
  let selectedCategoryID: UUID?
  let isSeeAllSelected: Bool
  @Binding var hoveredCategoryID: UUID?
  let onAddCategory: () -> Void
  let onSelectCategory: (CategoryItem) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Rectangle()
        .fill(Color.n40.opacity(0.24))
        .frame(height: 1)

      ZStack(alignment: .top) {
        ScrollView {
          VStack(alignment: .leading, spacing: 8) {
            Color.clear.frame(height: 38)
            ForEach(categories, id: \.id) { category in
              SidebarCategoryRow(
                category: category,
                countText: "\((category.links ?? []).count)개",
                isSelected: selectedCategoryID == category.id && !isSeeAllSelected,
                hoveredCategoryID: $hoveredCategoryID,
                onSelectCategory: onSelectCategory
              )
            }
          }
          .padding(.bottom, 56)
        }
        .scrollIndicators(.hidden)

        SidebarCategorySectionHeader(onAddCategory: onAddCategory)
      }
      .frame(maxHeight: .infinity)
    }
  }
}

