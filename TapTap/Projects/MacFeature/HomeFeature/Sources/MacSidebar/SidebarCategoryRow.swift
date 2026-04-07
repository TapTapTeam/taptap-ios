//
//  SidebarCategoryRow.swift
//  MacHomeFeature
//

import SwiftUI

import Core
import DesignSystem

struct SidebarCategoryRow: View {
  let category: CategoryItem
  let countText: String
  let isSelected: Bool
  @Binding var hoveredCategoryID: UUID?
  let onSelectCategory: (CategoryItem) -> Void

  private var isHovered: Bool { hoveredCategoryID == category.id }

  var body: some View {
    Button {
      onSelectCategory(category)
    } label: {
      HStack(spacing: 10) {
        DesignSystemAsset.categoryIcon(number: category.icon.number)
          .resizable()
          .frame(width: 24, height: 24)

        Text(category.categoryName)
          .font(.B1_SB)
          .foregroundStyle(SidebarForeground.text1)
          .lineLimit(1)
          .truncationMode(.tail)
          .frame(maxWidth: .infinity, alignment: .leading)

        if isHovered && !isSelected {
          SeeMoreButton()
            .padding(.trailing, 6)
        } else {
          Text(countText)
            .font(.B2_M)
            .foregroundStyle(SidebarForeground.caption2)
            .padding(.trailing, 6)
        }
      }
      .padding(.leading, 12)
      .padding(.trailing, 6)
      .frame(height: 36)
      .background(
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .fill(isSelected ? Color.bl1 : (isHovered ? Color.n20 : Color.clear))
      )
    }
    .buttonStyle(.plain)
    .onHover { isHovering in
      if isHovering {
        hoveredCategoryID = category.id
      } else if hoveredCategoryID == category.id {
        hoveredCategoryID = nil
      }
    }
  }
}

