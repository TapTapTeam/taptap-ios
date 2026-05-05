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
import MacLinkListFeature
import MacSearchFeature

/// macOS 앱 전역 레이아웃(사이드바 고정 + 디테일 전환)을 소유하는 컨테이너 뷰.
struct RootView: View {
  @Query(sort: \CategoryItem.createdAt) private var allCategories: [CategoryItem]
  @Query(sort: \ArticleItem.lastViewedDate, order: .reverse) private var articles: [ArticleItem]
  
  @State private var isSidebarCollapsed: Bool = false
  @State private var isSeeAllSelected: Bool = true
  @State private var selectedCategoryID: UUID?
  @State private var isLinkListEditing: Bool = false
  
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
          if !isLinkListEditing {
            MacToolbar(
              text: $searchViewModel.query,
              onSearchTap: {
                isSearchOverlayPresented = true
                searchViewModel.focus()
              }
            )
          }

          if searchViewModel.hasSubmittedSearch {
            SearchView(viewModel: searchViewModel)
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
          } else {
            detailContent
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
  
  private var detailContent: some View {
    LinkListContainerView(
      articles: articles,
      categories: allCategories,
      selectedCategoryID: selectedCategoryID,
      isSeeAllSelected: isSeeAllSelected,
      isEditing: $isLinkListEditing,
      onArticleTap: { article in
        print(article.title)
      }
    )
  }
}
