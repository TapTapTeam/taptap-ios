//
//  LinkListFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import Core
import Shared

@Reducer
public struct LinkListFeature {
  // MARK: - Dependencies
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.uuid) var uuid

  // MARK: - State
  @ObservableState
  public struct State: Equatable {
    // 자식 Feature 상태
    var categoryChipList = CategoryChipFeature.State()
    var articleList = ArticleFilterFeature.State()

    var allLinks: [ArticleItem] = []
    var selectedCategory: CategoryItem? = nil

    var selectedCategoryTitle: String = "카테고리"
    var alert: AlertBannerState? = nil

    var initialCategoryName: String = "전체"

    var bottomSheetCategories: IdentifiedArrayOf<CategoryProps> = []
    
    // 페이징 상태
    var currentPage: Int = 0
    let pageSize: Int = 50
    var isFetching: Bool = false
    var hasMore: Bool = true
    
    // 시트 상태 관리
    @Presents var editSheet: EditSheetFeature.State?
    @Presents var selectBottomSheet: SelectBottomSheetFeature.State?

    public init(initialCategoryName: String = "전체") {
      let trimmed = initialCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
      self.initialCategoryName = trimmed.isEmpty ? "전체" : trimmed
    }

    // 기본 init()도 필요하면 "전체"로
    public init() {
      self.initialCategoryName = "전체"
    }
  }

  public struct AlertBannerState: Equatable {
    let title: String
    let icon: Image
    let tint: Tint
    public enum Tint: Equatable { case danger, info, alert }
  }

  // MARK: - Action
  public enum Action: Equatable {
    /// 라이프사이클
    case onAppear

    /// 자식 Feature 액션
    case categoryChipList(CategoryChipFeature.Action)
    case articleList(ArticleFilterFeature.Action)

    /// UI 이벤트
    case bottomSheetButtonTapped
    case linkLongPressed(ArticleItem)
    case editButtonTapped
    case backButtonTapped
    case searchButtonTapped
    case refresh
    case moveToCategoryName(String)

    /// 시트 관련 액션
    case editSheet(PresentationAction<EditSheetFeature.Action>)
    case selectBottomSheet(PresentationAction<SelectBottomSheetFeature.Action>)

    /// 알럿 관련 액션
    case hideAlertBanner
    case showAlert(title: String, tint: AlertBannerState.Tint)

    /// 데이터 로드 관련
    case fetchLinks
    case fetchLinksResponse([ArticleItem])
    case fetchLinksResponseFailed(String)

    case fetchTotalCount
    case fetchTotalCountResponse(Int)

    case fetchCategories
    case responseCategoryItems([CategoryItem])

    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }

  // MARK: - Body
  public var body: some ReducerOf<Self> {
    Scope(state: \.categoryChipList, action: \.categoryChipList) {
      CategoryChipFeature()
    }

    Scope(state: \.articleList, action: \.articleList) {
      ArticleFilterFeature()
    }

    Reduce(self.uiReducer)
      .ifLet(\.$editSheet, action: \.editSheet) { EditSheetFeature() }
      .ifLet(\.$selectBottomSheet, action: \.selectBottomSheet) { SelectBottomSheetFeature() }

    Reduce(self.dataReducer)
  }

  public init() {}
}

// MARK: - UI Reducer
private extension LinkListFeature {
  func uiReducer(state: inout State, action: Action) -> Effect<Action> {
    switch action {

    case .onAppear:
      guard state.currentPage == 0 else { return .none }
      return .run { send in
        await send(.fetchCategories)
        await send(.fetchLinks)
        await send(.fetchTotalCount)
      }

    case .backButtonTapped:
      return .send(.delegate(.route(.back)))

    case .searchButtonTapped:
      return .send(.delegate(.route(.search)))

    case .editButtonTapped:
      state.editSheet = EditSheetFeature.State(link: nil)
      return .none

    case let .linkLongPressed(link):
      state.editSheet = EditSheetFeature.State(link: link)
      return .none

    case .bottomSheetButtonTapped:
      if !state.bottomSheetCategories.isEmpty {
        let current = state.selectedCategory?.categoryName ?? "전체"
        state.selectBottomSheet = SelectBottomSheetFeature.State(
          categories: state.bottomSheetCategories,
          selectedCategory: current
        )
        return .none
      }

      return .run { send in
        await send(.fetchCategories)
        await send(.bottomSheetButtonTapped)
      }

    case let .categoryChipList(.categoryTapped(category)):
      state.selectedCategory = category
      state.categoryChipList.selectedCategory = category
      state.selectBottomSheet?.selectedCategory = category.categoryName

      if category.categoryName == "전체" {
        state.articleList.link = state.allLinks
      } else {
        state.articleList.link = state.allLinks.filter {
          $0.category?.categoryName == category.categoryName
        }
      }
      return .send(.fetchTotalCount)

    case .editSheet(.presented(.delegate(.dismissSheet))):
      state.editSheet = nil
      return .none

    case .editSheet(.presented(.delegate(.moveLink))):
      state.editSheet = nil
      if state.articleList.link.isEmpty {
        return .send(.showAlert(title: "이 카테고리에 이동할 링크가 없어요", tint: .alert))
      }
      return .send(.delegate(.route(.moveLink(
        allLinks: state.articleList.link,
        categoryName: state.selectedCategory?.categoryName ?? "전체"
      ))))

    case let .moveToCategoryName(name):
      let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !name.isEmpty else { return .none }

      if let match = state.categoryChipList.categories.first(where: { $0.categoryName == name }) {
        state.selectedCategory = match
        state.categoryChipList.selectedCategory = match
        state.articleList.link = (name == "전체")
        ? state.allLinks
        : state.allLinks.filter { $0.category?.categoryName == name }
      } else {
        if let all = state.categoryChipList.categories.first(where: { $0.categoryName == "전체" }) {
          state.selectedCategory = all
          state.categoryChipList.selectedCategory = all
        } else {
          let all = CategoryItem(categoryName: "전체", icon: .init(number: 0))
          state.selectedCategory = all
          state.categoryChipList.selectedCategory = all
        }
        state.articleList.link = state.allLinks
      }
      return .send(.fetchTotalCount)

    case .editSheet(.presented(.delegate(.deleteLink))):
      state.editSheet = nil
      if state.articleList.link.isEmpty {
        return .send(.showAlert(title: "이 카테고리에 삭제할 링크가 없어요", tint: .alert))
      }
      return .send(.delegate(.route(.deleteLink(
        allLinks: state.articleList.link,
        categoryName: state.selectedCategory?.categoryName ?? "전체"
      ))))

    case let .showAlert(title, tint):
      state.alert = .init(
        title: title,
        icon: tint == .info ? Image(icon: Icon.badgeCheck) : Image(icon: Icon.alertCircle),
        tint: tint
      )
      return .run { send in
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        await send(.hideAlertBanner)
      }

    case .hideAlertBanner:
      state.alert = nil
      return .none

    case .selectBottomSheet(.presented(.delegate(.categorySelected(let name)))):
      guard let name else { return .none }
      return .send(.moveToCategoryName(name))

    case .selectBottomSheet(.presented(.delegate(.dismiss))):
      state.selectBottomSheet = nil
      return .none

    case let .articleList(.delegate(.longPressed(link))):
      return .send(.linkLongPressed(link))

    case let .articleList(.delegate(.route(route))):
      return .send(.delegate(.route(route)))

    case .articleList(.delegate(.loadMore)):
      return .send(.fetchLinks)

    case .delegate:
      return .none

    default:
      return .none
    }
  }
}

// MARK: - Data Reducer
private extension LinkListFeature {
  func dataReducer(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .fetchLinks:
      guard !state.isFetching && state.hasMore else { return .none }
      state.isFetching = true
      
      let limit = state.pageSize
      let offset = state.currentPage * state.pageSize
      
      return .run { send in
        
        do {
          let items = try swiftDataClient.link.fetchLinks(
            limit: limit,
            offset: offset
          )
          await send(.fetchLinksResponse(items))
        } catch {
          await send(.fetchLinksResponseFailed(error.localizedDescription))
        }
      }
      
    case .fetchLinksResponseFailed:
      state.isFetching = false
      return .send(.showAlert(title: "링크를 불러오지 못했어요", tint: .danger))
    case let .fetchLinksResponse(items):
      state.isFetching = false

      if items.isEmpty {
        state.hasMore = false
        return .none
      }

      let existingURLs = Set(state.allLinks.map { $0.urlString })
      let newItems = items.filter { !existingURLs.contains($0.urlString) }
      
      if newItems.isEmpty {
        state.hasMore = false
        return .none
      }

      state.allLinks.append(contentsOf: newItems)
      state.currentPage += 1

      let selectedName = state.selectedCategory?.categoryName ?? state.initialCategoryName
      
      let filteredLinks = selectedName == "전체" ? state.allLinks : state.allLinks.filter { $0.category?.categoryName == selectedName }
      switch state.articleList.sortOrder {
      case .latest:
        state.articleList.link = filteredLinks.sorted { $0.createAt > $1.createAt }
      case .oldest:
        state.articleList.link = filteredLinks.sorted { $0.createAt < $1.createAt }
      }

      return .none

    case .refresh:
      state.currentPage = 0
      state.allLinks = []
      state.hasMore = true
      state.isFetching = false
      return .run { send in
        await send(.fetchLinks)
        await send(.fetchTotalCount)
      }

    case .fetchTotalCount:
      let categoryName = state.selectedCategory?.categoryName ?? state.initialCategoryName
      return .run { send in
        do {
          let count: Int
          if categoryName == "전체" {
            count = try swiftDataClient.link.fetchLinksCount(predicate: nil)
          } else {
            count = try swiftDataClient.link.fetchLinksCount(
              predicate: #Predicate<ArticleItem> { $0.category?.categoryName == categoryName }
            )
          }
          await send(.fetchTotalCountResponse(count))
        } catch {
          print(error)
        }
      }

    case let .fetchTotalCountResponse(count):
      state.articleList.totalCount = count
      return .none

    case .fetchCategories:
      guard state.bottomSheetCategories.isEmpty else { return .none }
      return .run { send in
        let items = try swiftDataClient.category.fetchCategories()
        await send(.responseCategoryItems(items))
      }

    case .responseCategoryItems(let items):
      let allCategory = CategoryProps(id: uuid(), title: "전체")
      let reversed = items.reversed()
      var props = reversed.map { CategoryProps(id: uuid(), title: $0.categoryName) }
      props.insert(allCategory, at: 0)
      state.bottomSheetCategories = IdentifiedArray(uniqueElements: props)

      let allChip = CategoryItem(categoryName: "전체", icon: .init(number: 0))
      let chipCategories: [CategoryItem] = [allChip] + reversed.map {
        CategoryItem(categoryName: $0.categoryName, icon: $0.icon)
      }
      state.categoryChipList.categories = chipCategories

      let target = state.initialCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      ? "전체"
      : state.initialCategoryName

      if let match = chipCategories.first(where: { $0.categoryName == target }) {
        state.selectedCategory = match
        state.categoryChipList.selectedCategory = match
      } else {
        state.selectedCategory = allChip
        state.categoryChipList.selectedCategory = allChip
        state.initialCategoryName = "전체"
      }

      return .none

    default:
      return .none
    }
  }
}
