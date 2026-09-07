//
//  MoveLinkFeature.swift
//  Feature
//
//  Created by 이안 on 10/22/25.
//

import SwiftUI
import SwiftData

import ComposableArchitecture

import AnalyticsKit
import DesignSystem
import Core
import Shared

@Reducer
public struct MoveLinkFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.uuid) var uuid
  @Dependency(\.analytics) var analytics
  
  @ObservableState
  public struct State: Equatable {
    var allLinks: [ArticleItem] = []
    var categoryName: String = "전체"
    var totalCount: Int = 0
    var selectedLinks: Set<String> = []
    var isSelectAll: Bool = false
    var categories: [CategoryItem] = []
    var targetCategory: CategoryItem? = nil
    
    @Presents var selectBottomSheet: SelectBottomSheetFeature.State?
    
    public init(
      allLinks: [ArticleItem],
      categoryName: String,
      totalCount: Int
    ) {
      self.allLinks = allLinks
      self.categoryName = categoryName
      self.totalCount = totalCount
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case fetchLinksResponse([ArticleItem])
    case toggleSelect(ArticleItem)
    case backButtonTapped
    case confirmMoveTapped
    case openCategorySheet
    case fetchCategories
    case fetchCategoriesResponse([CategoryItem])
    case selectBottomSheet(PresentationAction<SelectBottomSheetFeature.Action>)
    case moveDone(count: Int)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce {
      state,
      action in
      switch action {
      case .onAppear:
        return .run { [categoryName = state.categoryName] send in
          do {
            let predicate: Foundation.Predicate<ArticleItem>?
            if categoryName == "전체" {
              predicate = nil
            } else {
              predicate = #Predicate<ArticleItem> { $0.category?.categoryName == categoryName }
            }
            let items = try swiftDataClient.link.fetchLinks(
              predicate: predicate,
              sortBy: [SortDescriptor(\.createAt, order: .reverse)]
            )
            await send(.fetchLinksResponse(items))
          } catch {
            print("Failed to fetch all links: \(error)")
          }
        }
        
      case let .fetchLinksResponse(items):
        state.allLinks = items
        if state.isSelectAll {
          state.selectedLinks = Set(items.map(\.id))
        }
        return .none
        
      case .binding(\.isSelectAll):
        if state.isSelectAll {
          state.selectedLinks = Set(state.allLinks.map(\.id))
        } else {
          state.selectedLinks.removeAll()
        }
        return .none
        
      case let .toggleSelect(link):
        if state.selectedLinks.contains(link.id) {
          state.selectedLinks.remove(link.id)
        } else {
          state.selectedLinks.insert(link.id)
        }
        state.isSelectAll = state.selectedLinks.count == state.allLinks.count
        return .none
        
      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .confirmMoveTapped:
        let selected = state.allLinks.filter { state.selectedLinks.contains($0.id) }
        guard !selected.isEmpty else { return .none }
        if state.categories.isEmpty {
          return .send(.fetchCategories)
        } else {
          return .send(.openCategorySheet)
        }
        
      case .fetchCategories:
        return .run { send in
          let items = try swiftDataClient.category.fetchCategories()
          await send(.fetchCategoriesResponse(items))
        }
        
      case let .fetchCategoriesResponse(items):
        state.categories = items
        return .send(.openCategorySheet)
        
      case .openCategorySheet:
        var props: [CategoryProps] = [CategoryProps(id: uuid(), title: "전체")]
        props.append(contentsOf: state.categories.map { CategoryProps(id: uuid(), title: $0.categoryName) })
        state.selectBottomSheet = .init(
          categories: .init(uniqueElements: props),
          selectedCategory: nil
        )
        return .none
        
      case .selectBottomSheet(.presented(.delegate(.categorySelected(let name)))):
        guard let name else {
          state.selectBottomSheet = nil
          return .none
        }
        
        let target = state.categories.first(where: { $0.categoryName == name })
        
        state.targetCategory = target
        let selected = state.allLinks.filter { state.selectedLinks.contains($0.id) }
        let moveCount = selected.count
        
        return .run { send in
          do {
            try swiftDataClient.link.moveLinks(selected, to: target)
          } catch {
            print("❌ moveLinks failed:", error)
          }
          await send(.moveDone(count: moveCount))
        }
        
      case let .moveDone(count):
        analytics.track(ConversionEvent.linkMovedToCategory(count: count))
        let moveCategoryName = state.targetCategory?.categoryName ?? "전체"
        return .run { send in
          try? await Task
            .sleep(
              nanoseconds: 500_000_000
            )
          NotificationCenter.default
            .post(
              name: .linkMoved,
              object: [
                "movedCount": count,
                "categoryName": moveCategoryName
              ]
            )
          await send(.delegate(.route(.back)))
        }
        
      case .selectBottomSheet(.presented(.delegate(.dismiss))):
        state.selectBottomSheet = nil
        return .none
        
      case .selectBottomSheet, .binding, .delegate:
        return .none
      }
    }
    .ifLet(\.$selectBottomSheet, action: \.selectBottomSheet) {
      SelectBottomSheetFeature()
    }
  }
  
  public init() {}
}
