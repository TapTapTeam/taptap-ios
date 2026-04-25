////
////  RootView.swift
////  TapTapMac
////
////  Created by 여성일 on 4/6/26.
////
import SwiftData
import SwiftUI

import Core
import DesignSystem

import MacHomeFeature
import MacSearchFeature

/// macOS 앱 전역 레이아웃(사이드바 고정 + 디테일 전환)을 소유하는 컨테이너 뷰.
struct RootView: View {
  @Query(sort: \CategoryItem.createdAt) private var allCategories: [CategoryItem]
  @Query(sort: \ArticleItem.lastViewedDate, order: .reverse) private var articles: [ArticleItem]
  
  @State private var isSidebarCollapsed: Bool = false
  @State private var isSeeAllSelected: Bool = true
  @State private var selectedCategoryID: UUID?
  
  @ObservedObject var searchViewModel: SearchViewModel
  @State private var isSearchOverlayPresented: Bool = false
  
  var body: some View {
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
          searchViewModel.clearSearch()
        },
        onAddCategory: { },
        onSelectCategory: { category in
          isSeeAllSelected = false
          selectedCategoryID = category.id
          searchViewModel.clearSearch()
        },
        onSettings: { }
      )
      .zIndex(1)
      
      ZStack(alignment: .top) {
        VStack(spacing: 0) {
          MacToolbar(
            text: $searchViewModel.query,
            onSearchTap: {
              isSearchOverlayPresented = true
              searchViewModel.focus()
            }
          )

          if searchViewModel.hasSubmittedSearch {
            SearchView(viewModel: searchViewModel)
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
          } else {
            detailHeader
            detailList
          }
        }
        
        if isSearchOverlayPresented {
          Color.black.opacity(0.16)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
              isSearchOverlayPresented = false
            }
          
          SearchDropdownPanel(
            viewModel: searchViewModel,
            onClose: {
              isSearchOverlayPresented = false
            }
          )
          .zIndex(10)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .background(Color.background)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear {
      searchViewModel.updateArticles(articles)
    }
    .onChange(of: articles) { _, newValue in
      searchViewModel.updateArticles(newValue)
    }
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

