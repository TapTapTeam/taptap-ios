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

import MacAddLinkFeature
import MacHomeFeature
import MacLinkListFeature
import MacSearchFeature

/// macOS 앱 전역 레이아웃(사이드바 고정 + 디테일 전환)을 소유하는 컨테이너 뷰.
struct RootView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \CategoryItem.createdAt) private var allCategories: [CategoryItem]
  @Query(sort: \ArticleItem.lastViewedDate, order: .reverse) private var articles: [ArticleItem]
  
  @State private var isSidebarCollapsed: Bool = false
  @State private var isSeeAllSelected: Bool = true
  @State private var selectedCategoryID: UUID?
  @State private var isLinkListEditing: Bool = false
  @State private var selectedDetail: DetailDestination = .linkList
  @State private var isSaveSuccessToastPresented: Bool = false
  @State private var saveSuccessCategoryName: String = "전체"
  
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
        onAddLink: {
          isLinkListEditing = false
          isSearchOverlayPresented = false
          isSaveSuccessToastPresented = false
          searchViewModel.clearSearch()
          isSeeAllSelected = false
          selectedCategoryID = nil
          selectedDetail = .addLink
        },
        onSeeAllLinks: {
          selectedDetail = .linkList
          isSaveSuccessToastPresented = false
          isSeeAllSelected = true
          selectedCategoryID = nil
          searchViewModel.clearSearch()
        },
        onAddCategory: { },
        onSelectCategory: { category in
          selectedDetail = .linkList
          isSaveSuccessToastPresented = false
          isSeeAllSelected = false
          selectedCategoryID = category.id
          searchViewModel.clearSearch()
        },
        onSettings: { }
      )
      .zIndex(1)
      
      ZStack(alignment: .top) {
        VStack(spacing: 0) {
          if selectedDetail == .linkList, !isLinkListEditing {
            MacToolbar(
              text: $searchViewModel.query,
              onSearchTap: {
                isSearchOverlayPresented = true
                searchViewModel.focus()
              }
            )
          }

          if selectedDetail == .linkList, searchViewModel.hasSubmittedSearch {
            SearchView(viewModel: searchViewModel) { item in
              item.lastViewedDate = Date()
              try? modelContext.save()
            }
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
        
        if isSaveSuccessToastPresented {
          SaveSuccessToast(
            categoryName: saveSuccessCategoryName,
            onClose: {
              isSaveSuccessToastPresented = false
            }
          )
          .frame(maxWidth: 560)
          .padding(.horizontal, 20)
          .padding(.top, 60)
          .zIndex(20)
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
    Group {
      switch selectedDetail {
      case .linkList:
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

      case .addLink:
        AddLinkView(
          categories: allCategories,
          totalLinkCount: articles.count,
          onSave: { article in
            showSavedLink(article)
          },
          onShowExistingLink: {
            selectedDetail = .linkList
            isSeeAllSelected = true
            selectedCategoryID = nil
          }
        )
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
  
  private func showSavedLink(_ article: ArticleItem) {
    selectedDetail = .linkList
    isLinkListEditing = false
    isSearchOverlayPresented = false
    searchViewModel.clearSearch()
    
    if let category = article.category {
      isSeeAllSelected = false
      selectedCategoryID = category.id
      saveSuccessCategoryName = category.categoryName
    } else {
      isSeeAllSelected = true
      selectedCategoryID = nil
      saveSuccessCategoryName = "전체"
    }
    
    isSaveSuccessToastPresented = true
  }
}

private enum DetailDestination: Equatable {
  case linkList
  case addLink
}

private struct SaveSuccessToast: View {
  let categoryName: String
  let onClose: () -> Void
  
  var body: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 2) {
        Text("링크를 저장했어요!")
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(Color.text1)
        
        Text("\(categoryName)에서 확인할 수 있어요")
          .font(.system(size: 12, weight: .medium))
          .foregroundStyle(Color.caption1)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 8)
      .padding(.vertical, 15)
      
      ToastCloseButtonWithoutHover {
        onClose()
      }
    }
    .padding(.horizontal, 16)
    .background(Color.bl1)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .strokeBorder(Color.bl6, lineWidth: 1.5)
    }
    .shadow(color: Color.bgShadow5, radius: 8, x: 0, y: 0)
    .shadow(color: Color.bgShadow5, radius: 4, x: 0, y: 2)
  }
}

private struct ToastCloseButtonWithoutHover: View {
  let onTap: () -> Void
  
  var body: some View {
    Button(action: onTap) {
      Image(icon: Icon.x)
        .resizable()
        .frame(width: 24, height: 24)
        .foregroundStyle(Color.icon)
        .frame(width: 40, height: 40)
        .contentShape(RoundedRectangle(cornerRadius: 8))
    }
    .buttonStyle(.plain)
  }
}
