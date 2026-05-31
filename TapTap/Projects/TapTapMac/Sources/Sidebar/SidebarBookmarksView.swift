//
//  SidebarBookmarksView.swift
//  MacHomeFeature
//

import SwiftUI

import Core
import DesignSystem

struct SidebarBookmarksView: View {
  let categories: [CategoryItem]
  let selectedCategoryID: UUID?
  let isSeeAllSelected: Bool
  @Binding var hoveredCategoryID: UUID?
  @Binding var presentedMenuCategoryID: UUID?
  let onSelectCategory: (CategoryItem) -> Void
  let onToggleCategoryFavorite: (UUID) -> Void
  let onDeleteCategory: (UUID) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Rectangle()
        .fill(Color.n40.opacity(0.24))
        .frame(height: 1)

      Text("즐겨찾는 카테고리")
        .font(.B2_M)
        .foregroundStyle(SidebarForeground.caption3)
        .frame(height: 32, alignment: .center)
        .padding(.leading, 4)

      VStack(alignment: .leading, spacing: 8) {
        ForEach(categories, id: \.id) { category in
          SidebarCategoryRow(
            categoryID: category.id,
            categoryName: category.categoryName,
            iconNumber: category.icon.number,
            isFavorite: category.isFavorite,
            countText: "\((category.links ?? []).count)개",
            isSelected: selectedCategoryID == category.id && !isSeeAllSelected,
            hoveredCategoryID: $hoveredCategoryID,
            presentedMenuCategoryID: $presentedMenuCategoryID,
            onSelectCategory: { _ in onSelectCategory(category) },
            onToggleFavorite: onToggleCategoryFavorite,
            onDeleteCategory: onDeleteCategory
          )
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 6)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
