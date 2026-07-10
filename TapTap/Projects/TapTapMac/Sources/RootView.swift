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
  @State private var isAddCategoryPopoverPresented: Bool = false
  @State private var newCategoryName: String = ""
  @State private var selectedNewCategoryIconNumber: Int = 1
  @State private var isDuplicateCategoryName: Bool = false
  
  @ObservedObject var searchViewModel: SearchViewModel
  @State private var isSearchOverlayPresented: Bool = false
  
  @State private var wasAutoCollapsed: Bool = false
  @State private var currentWidth: CGFloat = 0
  private let sidebarCollapseThreshold: CGFloat = 860
  
  var body: some View {
    GeometryReader { geometry in
      contentView
        .onChange(of: geometry.size.width) { _, newWidth in
          currentWidth = newWidth
          if newWidth < sidebarCollapseThreshold && !isSidebarCollapsed {
            withAnimation(.easeInOut(duration: 0.2)) { isSidebarCollapsed = true }
            wasAutoCollapsed = true
          }
          if newWidth >= sidebarCollapseThreshold && isSidebarCollapsed && wasAutoCollapsed {
            withAnimation(.easeInOut(duration: 0.2)) { isSidebarCollapsed = false }
            wasAutoCollapsed = false
          }
        }
    }
    .frame(minWidth: 640, minHeight: 450)
  }
  
  private var contentView: some View {
    ZStack(alignment: .top) {
      HStack(spacing: 0) {
        if !isSidebarCollapsed {
          MacSidebarView(
            totalLinkCount: articles.count,
            favoriteCategories: favoriteCategories,
            categories: categoriesForList,
            isSeeAllSelected: isSeeAllSelected,
            selectedCategoryID: selectedCategoryID,
            isCollapsed: isSidebarCollapsed,
            onToggleSidebar: toggleSidebar,
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
            onAddCategory: showAddCategoryPopover,
            onSelectCategory: { category in
              selectedDetail = .linkList
              isSaveSuccessToastPresented = false
              isSeeAllSelected = false
              selectedCategoryID = category.id
              searchViewModel.clearSearch()
            },
            onToggleCategoryFavorite: toggleCategoryFavorite,
            onDeleteCategory: deleteCategory,
            onSettings: { }
          )
          .transition(.move(edge: .leading).combined(with: .opacity))
          .zIndex(100)
        }

        ZStack(alignment: .top) {
          contentStack

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
      .overlay(alignment: .topLeading) {
        if isSidebarCollapsed {
          Button(action: toggleSidebar) {
            SidebarToggleIcon(isCollapsed: true)
          }
          .buttonStyle(.plain)
          .padding(.top, 20)
          .padding(.leading, 20)
        }
      }
      .overlay {
        if isAddCategoryPopoverPresented {
          Color.bgDim
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
              closeAddCategoryPopover()
            }

          AddCategoryPopover(
            categoryName: $newCategoryName,
            selectedIconNumber: $selectedNewCategoryIconNumber,
            isDuplicateName: isDuplicateCategoryName,
            onClose: closeAddCategoryPopover,
            onSave: saveNewCategory
          )
          .zIndex(30)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .onAppear {
        searchViewModel.updateArticles(articles)
      }
      .onChange(of: articles) { _, newValue in
        searchViewModel.updateArticles(newValue)
      }
      .onChange(of: newCategoryName) { _, _ in
        isDuplicateCategoryName = false
      }

      if isSearchOverlayPresented {
        Color.black.opacity(0.16)
          .ignoresSafeArea()
          .contentShape(Rectangle())
          .onTapGesture {
            isSearchOverlayPresented = false
          }
          .zIndex(1)
      }

      if isSearchOverlayPresented {
        HStack(spacing: 0) {
          if !isSidebarCollapsed {
            Color.clear.frame(width: 290)
          }
          VStack(spacing: 0) {
            SearchDropdownPanel(
              viewModel: searchViewModel,
              onClose: {
                isSearchOverlayPresented = false
              }
            )
            Spacer()
          }
          .frame(maxWidth: .infinity)
        }
        .zIndex(2)
      }
    }
  }
  
  private func toggleSidebar() {
    withAnimation(.easeInOut(duration: 0.2)) {
      isSidebarCollapsed.toggle()
    }
  }
  
  private var favoriteCategories: [CategoryItem] {
    allCategories.filter(\.isFavorite)
  }
  
  private var categoriesForList: [CategoryItem] {
    allCategories.filter { !$0.isFavorite }
  }
  
  private var contentStack: some View {
    VStack(spacing: 0) {
      if selectedDetail == .linkList, !isLinkListEditing {
        MacToolbar(
          text: $searchViewModel.query,
          onSearchTap: {
            isSearchOverlayPresented = true
            searchViewModel.focus()
          },
          backForwardLeadingPadding: isSidebarCollapsed ? 72 : 20
        )
      }
      
      if selectedDetail == .linkList, searchViewModel.hasSubmittedSearch {
        searchContent
      } else {
        detailContent
      }
    }
  }
  
  private var searchContent: some View {
    SearchView(viewModel: searchViewModel, onArticleTap: { item in
      item.lastViewedDate = Date()
      try? modelContext.save()
    })
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
  
  private func showAddCategoryPopover() {
    isSearchOverlayPresented = false
    isSaveSuccessToastPresented = false
    newCategoryName = ""
    selectedNewCategoryIconNumber = 1
    isDuplicateCategoryName = false
    isAddCategoryPopoverPresented = true
  }
  
  private func closeAddCategoryPopover() {
    isAddCategoryPopoverPresented = false
    newCategoryName = ""
    selectedNewCategoryIconNumber = 1
    isDuplicateCategoryName = false
  }
  
  private func saveNewCategory() {
    let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedName.isEmpty else { return }
    
    let isDuplicate = allCategories.contains {
      $0.categoryName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == trimmedName.lowercased()
    } || trimmedName.lowercased() == "전체"
    
    guard !isDuplicate else {
      isDuplicateCategoryName = true
      return
    }
    
    let newCategory = CategoryItem(
      categoryName: trimmedName,
      icon: CategoryIcon(number: selectedNewCategoryIconNumber)
    )
    
    modelContext.insert(newCategory)
    
    do {
      try modelContext.save()
      isSeeAllSelected = false
      selectedCategoryID = newCategory.id
      closeAddCategoryPopover()
    } catch {
      modelContext.delete(newCategory)
      isDuplicateCategoryName = true
    }
  }
  
  private func toggleCategoryFavorite(_ categoryID: UUID) {
    do {
      try CategoryCommand(context: modelContext).toggleFavorite(id: categoryID)
    } catch {
      print("Failed to toggle category favorite: \(error)")
    }
  }
  
  private func deleteCategory(_ categoryID: UUID) {
    do {
      if selectedCategoryID == categoryID {
        selectedDetail = .linkList
        isSeeAllSelected = true
        selectedCategoryID = nil
      }
      
      try CategoryCommand(context: modelContext).deleteCategory(id: categoryID)
    } catch {
      print("Failed to delete category: \(error)")
    }
  }
  
  private var detailContent: some View {
    LinkListContainerView(
      articles: articles,
      categories: allCategories,
      selectedCategoryID: selectedCategoryID,
      isSeeAllSelected: isSeeAllSelected,
      isEditing: $isLinkListEditing
    )
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
