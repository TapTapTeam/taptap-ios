//
//  SidebarCategoryListView.swift
//  TapTapMac
//

import SwiftUI

import Core
import DesignSystem

struct SidebarCategoryListView: View {
  let categories: [CategoryItem]
  let selectedCategoryID: UUID?
  let isSeeAllSelected: Bool
  @Binding var hoveredCategoryID: UUID?
  @Binding var presentedMenuCategoryID: UUID?
  let onAddCategory: () -> Void
  let onSelectCategory: (CategoryItem) -> Void
  let onToggleCategoryFavorite: (UUID) -> Void
  let onDeleteCategory: (UUID) -> Void

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
          .padding(.bottom, 56)
        }
        .scrollIndicators(.hidden)

        SidebarCategorySectionHeader(onAddCategory: onAddCategory)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
