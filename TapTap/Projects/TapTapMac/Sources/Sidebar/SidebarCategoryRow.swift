//
//  SidebarCategoryRow.swift
//  MacHomeFeature
//

import SwiftUI

import Core
import DesignSystem

struct SidebarCategoryRow: View {
  let categoryID: UUID
  let categoryName: String
  let iconNumber: Int
  let isFavorite: Bool
  let countText: String
  let isSelected: Bool
  @Binding var hoveredCategoryID: UUID?
  let onSelectCategory: (UUID) -> Void
  let onToggleFavorite: (UUID) -> Void
  let onDeleteCategory: (UUID) -> Void

  @State private var isMenuPresented: Bool = false

  private var isHovered: Bool { hoveredCategoryID == categoryID }

  var body: some View {
    HStack(spacing: 10) {
      DesignSystemAsset.categoryIcon(number: iconNumber)
        .resizable()
        .frame(width: 24, height: 24)

      Text(categoryName)
        .font(.B1_SB)
        .foregroundStyle(SidebarForeground.text1)
        .lineLimit(1)
        .truncationMode(.tail)
        .frame(maxWidth: .infinity, alignment: .leading)

      if isHovered || isMenuPresented {
        Button {
          isMenuPresented.toggle()
        } label: {
          SeeMoreButton()
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isMenuPresented, arrowEdge: .trailing) {
          SidebarCategoryMorePopup(
            favoriteTitle: isFavorite ? "즐겨찾기에서 제거하기" : "즐겨찾기에 추가하기",
            onToggleFavorite: {
              isMenuPresented = false
              onToggleFavorite(categoryID)
            },
            onOpenInNewTab: { isMenuPresented = false },
            onEdit: { isMenuPresented = false },
            onDelete: {
              isMenuPresented = false
              onDeleteCategory(categoryID)
            }
          )
        }
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
    .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36, alignment: .leading)
    .contentShape(Rectangle())
    .background(
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(isSelected ? Color.bl1 : (isHovered ? Color.n20 : Color.clear))
    )
    .frame(maxWidth: .infinity, alignment: .leading)
    .onTapGesture {
      onSelectCategory(categoryID)
    }
    .onHover { isHovering in
      if isHovering {
        hoveredCategoryID = categoryID
      } else if hoveredCategoryID == categoryID {
        hoveredCategoryID = nil
      }
    }
  }
}

private struct SidebarCategoryMorePopup: View {
  let favoriteTitle: String
  let onToggleFavorite: () -> Void
  let onOpenInNewTab: () -> Void
  let onEdit: () -> Void
  let onDelete: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      SidebarCategoryMorePopupButton(
        title: favoriteTitle,
        icon: Icon.bookmark,
        action: onToggleFavorite
      )

      Rectangle()
        .fill(Color.divider1)
        .frame(height: 0.5)

      SidebarCategoryMorePopupButton(
        title: "새 탭에서 열기",
        icon: Icon.openWindow,
        action: onOpenInNewTab
      )

      SidebarCategoryMorePopupButton(
        title: "카테고리 편집하기",
        icon: Icon.macEdit,
        action: onEdit
      )

      SidebarCategoryMorePopupButton(
        title: "카테고리 삭제하기",
        icon: Icon.trash,
        foregroundColor: Color.danger,
        backgroundColor: Color.bgDimDanger,
        action: onDelete
      )
    }
    .padding(4)
    .frame(width: 168, alignment: .leading)
    .background(Color.n0)
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .strokeBorder(Color.divider2, lineWidth: 0.5)
    }
    .shadow(color: Color.bgShadow2, radius: 4, x: 0, y: 2)
    .shadow(color: Color.bgShadow1, radius: 6, x: 0, y: 2)
  }
}

private struct SidebarCategoryMorePopupButton: View {
  let title: String
  let icon: String
  var foregroundColor: Color = Color.text1
  var backgroundColor: Color = Color.clear
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        Image(icon: icon)
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(width: 16, height: 16)
          .foregroundStyle(foregroundColor)

        Text(title)
          .font(.B2_M)
          .foregroundStyle(foregroundColor)
          .lineLimit(1)
          .frame(width: 95, alignment: .leading)
      }
      .padding(.leading, 8)
      .padding(.trailing, 40)
      .padding(.vertical, 6)
      .frame(width: 160, alignment: .leading)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
      .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
    .buttonStyle(.plain)
  }
}
