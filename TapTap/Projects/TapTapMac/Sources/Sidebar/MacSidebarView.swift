//
//  MacSidebarView.swift
//  TapTapMac
//

import SwiftUI

import Core
import DesignSystem

public struct MacSidebarView: View {
  let totalLinkCount: Int
  let favoriteCategories: [CategoryItem]
  let categories: [CategoryItem]
  let isSeeAllSelected: Bool
  let selectedCategoryID: UUID?
  let isCollapsed: Bool

  public var onToggleSidebar: () -> Void
  public var onAddLink: () -> Void
  public var onSeeAllLinks: () -> Void
  public var onAddCategory: () -> Void
  public var onSelectCategory: (CategoryItem) -> Void
  public var onToggleCategoryFavorite: (UUID) -> Void
  public var onEditCategory: (UUID) -> Void
  public var onDeleteCategory: (UUID) -> Void
  public var onSettings: () -> Void
  
  @State private var hoveredCategoryID: UUID?
  @State private var presentedMenuCategoryID: UUID?

  public init(
    totalLinkCount: Int,
    favoriteCategories: [CategoryItem],
    categories: [CategoryItem],
    isSeeAllSelected: Bool,
    selectedCategoryID: UUID?,
    isCollapsed: Bool,
    onToggleSidebar: @escaping () -> Void,
    onAddLink: @escaping () -> Void,
    onSeeAllLinks: @escaping () -> Void,
    onAddCategory: @escaping () -> Void,
    onSelectCategory: @escaping (CategoryItem) -> Void,
    onToggleCategoryFavorite: @escaping (UUID) -> Void,
    onEditCategory: @escaping (UUID) -> Void = { _ in },
    onDeleteCategory: @escaping (UUID) -> Void,
    onSettings: @escaping () -> Void
  ) {
    self.totalLinkCount = totalLinkCount
    self.favoriteCategories = favoriteCategories
    self.categories = categories
    self.isSeeAllSelected = isSeeAllSelected
    self.selectedCategoryID = selectedCategoryID
    self.isCollapsed = isCollapsed
    self.onToggleSidebar = onToggleSidebar
    self.onAddLink = onAddLink
    self.onSeeAllLinks = onSeeAllLinks
    self.onAddCategory = onAddCategory
    self.onSelectCategory = onSelectCategory
    self.onToggleCategoryFavorite = onToggleCategoryFavorite
    self.onEditCategory = onEditCategory
    self.onDeleteCategory = onDeleteCategory
    self.onSettings = onSettings
  }

  public var body: some View {
    let width: CGFloat = isCollapsed ? 56 : 272
    let sidebarShape = UnevenRoundedRectangle(
      topLeadingRadius: 0,
      bottomLeadingRadius: 0,
      bottomTrailingRadius: 16,
      topTrailingRadius: 16,
      style: .continuous
    )

    ZStack(alignment: .bottomLeading) {
      sidebarShape
        .fill(Color.n0)
        .shadow(color: .bgShadow2, radius: 2, x: 0, y: 2)
        .shadow(color: .bgShadow1, radius: 3, x: 0, y: 2)

      VStack(alignment: .leading, spacing: 16) {
        SidebarHeaderView(
          isCollapsed: isCollapsed,
          onToggleSidebar: onToggleSidebar
        )
        if !isCollapsed {
          SidebarMyLinksView(
            totalLinkCount: totalLinkCount,
            isSeeAllSelected: isSeeAllSelected,
            onAddLink: onAddLink,
            onSeeAllLinks: onSeeAllLinks
          )
          SidebarBookmarksView(
            categories: favoriteCategories,
            selectedCategoryID: selectedCategoryID,
            isSeeAllSelected: isSeeAllSelected,
            hoveredCategoryID: $hoveredCategoryID,
            presentedMenuCategoryID: $presentedMenuCategoryID,
            onSelectCategory: onSelectCategory,
            onToggleCategoryFavorite: onToggleCategoryFavorite,
            onDeleteCategory: onDeleteCategory
          )
          SidebarCategoryListView(
            categories: categories,
            selectedCategoryID: selectedCategoryID,
            isSeeAllSelected: isSeeAllSelected,
            hoveredCategoryID: $hoveredCategoryID,
            presentedMenuCategoryID: $presentedMenuCategoryID,
            onAddCategory: onAddCategory,
            onSelectCategory: onSelectCategory,
            onToggleCategoryFavorite: onToggleCategoryFavorite,
            onDeleteCategory: onDeleteCategory
          )
        }
      }
      .padding(.top, isCollapsed ? 8 : 16)
      .padding(.horizontal, isCollapsed ? 8 : 16)
      .padding(.bottom, 20)
      .zIndex(2)

      // 카테고리 목록 위에 얹혀 하단으로 스크롤되는 행을 흐리게 없앤다.
      // 반드시 콘텐츠(zIndex 2)보다 위, 설정 버튼(zIndex 4)보다 아래여야 보인다.
      VStack {
        Spacer()
        LinearGradient(
          stops: [
            Gradient.Stop(color: .bgButtonGrad4, location: 0.0),
            Gradient.Stop(color: .n0, location: 0.7)
          ],
          startPoint: UnitPoint(x: 0.44, y: 0),
          endPoint: UnitPoint(x: 0.44, y: 1)
        )
        .frame(height: 72)
        .blur(radius: 4)
      }
      .clipShape(sidebarShape)
      .allowsHitTesting(false)
      .zIndex(3)

      if !isCollapsed {
        SidebarSettingsButton(onSettings: onSettings)
          .padding(.leading, 20)
          .padding(.bottom, 20)
          .zIndex(4)
      }
    }
    .frame(width: width, alignment: .leading)
    .frame(maxHeight: .infinity, alignment: .topLeading)
    .ignoresSafeArea(edges: .vertical)
    .contentShape(Rectangle())
    .overlayPreferenceValue(SidebarCategoryMenuAnchorPreferenceKey.self) { anchors in
      GeometryReader { proxy in
        if presentedMenuCategoryID != nil {
          Color.clear
            .contentShape(Rectangle())
            .frame(width: 10_000, height: 10_000)
            .offset(x: -2_000, y: -2_000)
            .onTapGesture {
              presentedMenuCategoryID = nil
            }
            .zIndex(999)
        }

        if
          let categoryID = presentedMenuCategoryID,
          let anchor = anchors[categoryID],
          let category = category(id: categoryID)
        {
          let rect = proxy[anchor]

          SidebarCategoryMorePopup(
            favoriteTitle: category.isFavorite ? "즐겨찾기에서 제거하기" : "즐겨찾기에 추가하기",
            onToggleFavorite: {
              presentedMenuCategoryID = nil
              onToggleCategoryFavorite(categoryID)
            },
            onOpenInNewTab: { presentedMenuCategoryID = nil },
            onEdit: {
              presentedMenuCategoryID = nil
              onEditCategory(categoryID)
            },
            onDelete: {
              presentedMenuCategoryID = nil
              onDeleteCategory(categoryID)
            }
          )
          .offset(x: rect.minX, y: rect.minY)
          .zIndex(1000)
        }
      }
    }
  }

  private func category(id: UUID) -> CategoryItem? {
    favoriteCategories.first { $0.id == id } ?? categories.first { $0.id == id }
  }
}
