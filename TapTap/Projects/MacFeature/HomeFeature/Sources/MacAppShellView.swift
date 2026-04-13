//
//  MacAppShellView.swift
//  MacHomeFeature
//

import SwiftData
import SwiftUI

import Core
import DesignSystem

/// macOS 앱 전역 레이아웃(사이드바 고정 + 디테일 전환)을 소유하는 컨테이너 뷰.
public struct MacAppShellView: View {
  @Query(sort: \CategoryItem.createdAt) private var allCategories: [CategoryItem]
  @Query(sort: \ArticleItem.lastViewedDate, order: .reverse) private var articles: [ArticleItem]

  @State private var isSidebarCollapsed: Bool = false
  @State private var isSeeAllSelected: Bool = true
  @State private var selectedCategoryID: UUID?

  public init() {}

  public var body: some View {
    HStack(spacing: 0) {
      MacSidebarView(
        totalLinkCount: articles.count,
        favoriteCategories: favoriteCategories,
        categories: categoriesForList,
        isSeeAllSelected: isSeeAllSelected,
        selectedCategoryID: selectedCategoryID,
        isCollapsed: isSidebarCollapsed,
        onToggleSidebar: { withAnimation(.easeInOut(duration: 0.2)) { isSidebarCollapsed.toggle() } },
        onAddLink: { },
        onSeeAllLinks: {
          isSeeAllSelected = true
          selectedCategoryID = nil
        },
        onAddCategory: { },
        onSelectCategory: { category in
          isSeeAllSelected = false
          selectedCategoryID = category.id
        },
        onSettings: { }
      )
      .zIndex(1)

      VStack(spacing: 0) {
        detailHeader
        detailList
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .background(Color.background)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var favoriteCategories: [CategoryItem] {
    allCategories.filter(\.isFavorite)
  }

  private var categoriesForList: [CategoryItem] {
    allCategories.filter { !$0.isFavorite }
  }

  private var detailTitle: String {
    if isSeeAllSelected { return "모든 링크" }
    if let id = selectedCategoryID,
       let name = allCategories.first(where: { $0.id == id })?.categoryName {
      return name
    }
    return "링크"
  }

  private var displayedArticles: [ArticleItem] {
    guard !isSeeAllSelected, let id = selectedCategoryID else { return articles }
    return articles.filter { $0.category?.id == id }
  }

  private var detailHeader: some View {
    HStack {
      Text(detailTitle)
        .font(.H3)
        .foregroundStyle(Color.text1)
      Spacer()
    }
    .padding(.horizontal, 20)
    .padding(.top, 16)
    .padding(.bottom, 12)
  }

  private var detailList: some View {
    List(displayedArticles) { article in
      VStack(alignment: .leading, spacing: 4) {
        Text(article.title)
          .font(.B1_M)
        Text(article.urlString)
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
      .padding(.vertical, 4)
    }
    .listStyle(.inset)
  }
}

