//
//  MacSidebarView.swift
//  MacHomeFeature
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
  public var onSettings: () -> Void
  
  @State private var hoveredCategoryID: UUID?

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
    self.onSettings = onSettings
  }

  public var body: some View {
    let width: CGFloat = isCollapsed ? 56 : 290
    ZStack(alignment: .bottomLeading) {
      Color.n0

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
            onSelectCategory: onSelectCategory
          )
          SidebarCategoryListView(
            categories: categories,
            selectedCategoryID: selectedCategoryID,
            isSeeAllSelected: isSeeAllSelected,
            hoveredCategoryID: $hoveredCategoryID,
            onAddCategory: onAddCategory,
            onSelectCategory: onSelectCategory
          )
        }
      }
      .padding(.top, isCollapsed ? 8 : 16)
      .padding(.horizontal, isCollapsed ? 8 : 16)
      .padding(.bottom, 20)

      VStack {
        Spacer()
        LinearGradient(
          colors: [Color.bgButtonGrad4, Color.n0],
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: 72)
        .allowsHitTesting(false)
      }

      if isCollapsed {
        SidebarSettingsButton(onSettings: onSettings)
          .padding(.leading, 8)
          .padding(.bottom, 20)
      } else {
        SidebarSettingsButton(onSettings: onSettings)
          .padding(.leading, 20)
          .padding(.bottom, 20)
      }
    }
    .frame(width: width, alignment: .leading)
    .frame(maxHeight: .infinity, alignment: .topLeading)
    .ignoresSafeArea(edges: .vertical)
    .contentShape(Rectangle())
    .clipShape(
      UnevenRoundedRectangle(
        topLeadingRadius: 0,
        bottomLeadingRadius: 0,
        bottomTrailingRadius: 16,
        topTrailingRadius: 16,
        style: .continuous
      )
    )
    .shadow(color: .bgShadow2, radius: 2, x: 0, y: 2)
    .shadow(color: .bgShadow1, radius: 3, x: 0, y: 2)
  }
}

