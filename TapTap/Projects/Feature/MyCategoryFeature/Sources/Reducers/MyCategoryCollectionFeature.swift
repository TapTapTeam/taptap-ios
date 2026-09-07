//
//  MyCategoryCollectionFeature.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import ComposableArchitecture

import AnalyticsKit
import Core
import Shared

@Reducer
public struct MyCategoryCollectionFeature {
  @ObservableState
  public struct State: Equatable {
    var categoryGrid = CategoryGridFeature.State()
    var selectedCategory: CategoryItem?
    var settingModal: CategorySettingFeature.State?
    var favoriteModal: CategoryFavoriteFeature.State?
    var favoriteFullAlert: CategoryItem?
    var myCategoryGrid = MyCategoryGridFeature.State()
    var allLinksCount = 0
    var showToast: Bool = false
    var toastMessage: String = ""

    public init() { }
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case settingButtonTapped
    case categoryGrid(CategoryGridFeature.Action)
    case settingModal(CategorySettingFeature.Action)
    case favoriteModal(CategoryFavoriteFeature.Action)
    case favoriteFullAlertCancelled
    case favoriteFullAlertConfirmed
    case totalLinkTapped
    case myCategoryGrid(MyCategoryGridFeature.Action)
    case fetchArticleResponse([ArticleItem])
    case fetchArticleFailed(String)
    case onAppear
    case showToast(String)
    case hideToast
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.analytics) var analytics

  private let favoriteLimit = 6

  public var body: some ReducerOf<Self> {
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    
    Scope(state: \.myCategoryGrid, action: \.myCategoryGrid) {
         MyCategoryGridFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .send(.delegate(.route(.back)))
        
      case .totalLinkTapped:
        return .send(.delegate(.route(.linkList(initCategory: "전체"))))
        
      case .settingButtonTapped:
        state.settingModal = CategorySettingFeature.State()
        return .none
        
      case .categoryGrid(_):
        return .none
        
      case .onAppear:
        analytics.track(UsageEvent.screenViewed(.myCategory))
        return .run { send in
          do {
            let links = try swiftDataClient.link.fetchLinks()
            await send(.fetchArticleResponse(links))
          } catch {
            await send(.fetchArticleFailed(error.localizedDescription))
          }
        }
        
      case .settingModal(.dismissButtonTapped):
        state.settingModal = nil
        return .none
        
      case .settingModal(.addButtonTapped):
        state.settingModal = nil
        return .send(.delegate(.route(.addCategory)))
        
      case .settingModal(.editButtonTapped):
        state.settingModal = nil
        return .send(.delegate(.route(.editCategory)))
        
      case .settingModal(.deleteButtonTapped):
        state.settingModal = nil
        return .send(.delegate(.route(.deleteCategory)))
        
      case .myCategoryGrid(.delegate(.route(let route))):
        return .send(.delegate(.route(route)))

      case let .myCategoryGrid(.delegate(.favoriteLongPressed(category))):
        state.favoriteModal = CategoryFavoriteFeature.State(category: category)
        return .none

      case .myCategoryGrid(_):
        return .none

      case .favoriteModal(.dismissButtonTapped):
        state.favoriteModal = nil
        return .none

      case .favoriteModal(.toggleButtonTapped):
        guard let category = state.favoriteModal?.category else { return .none }
        state.favoriteModal = nil
        let categoryID = category.id

        if category.isFavorite {
          analytics.track(UsageEvent.categoryFavoriteToggled(isFavorite: false))
          return .run { send in
            try? swiftDataClient.category.setFavorite(id: categoryID, isFavorite: false)
            await send(.myCategoryGrid(.onAppear))
            await send(.showToast("즐겨찾기를 해제했어요"))
          }
        }

        let favoriteCount = state.myCategoryGrid.categories.filter(\.isFavorite).count
        if favoriteCount >= favoriteLimit {
          state.favoriteFullAlert = category
          return .none
        }
        analytics.track(UsageEvent.categoryFavoriteToggled(isFavorite: true))
        return .run { send in
          try? swiftDataClient.category.setFavorite(id: categoryID, isFavorite: true)
          await send(.myCategoryGrid(.onAppear))
          await send(.showToast("즐겨찾기에 추가했어요"))
        }

      case .favoriteFullAlertCancelled:
        state.favoriteFullAlert = nil
        return .none

      case .favoriteFullAlertConfirmed:
        guard let category = state.favoriteFullAlert else { return .none }
        state.favoriteFullAlert = nil
        let newID = category.id
        let oldestFavoriteID = state.myCategoryGrid.categories
          .filter(\.isFavorite)
          .min(by: { $0.createdAt < $1.createdAt })?
          .id
        return .run { send in
          if let oldestFavoriteID {
            try? swiftDataClient.category.setFavorite(id: oldestFavoriteID, isFavorite: false)
          }
          try? swiftDataClient.category.setFavorite(id: newID, isFavorite: true)
          await send(.myCategoryGrid(.onAppear))
          await send(.showToast("즐겨찾기에 추가했어요"))
        }
      
      case let .fetchArticleResponse(articles):
        state.allLinksCount = articles.count
        return .none

      case .fetchArticleFailed:
        return .none
        
      case .showToast(let message):
        state.showToast = true
        state.toastMessage = message
        return .run { send in
          try await Task.sleep(for: .seconds(2))
          await send(.hideToast)
        }
        
      case .hideToast:
        state.showToast = false
        state.toastMessage = ""
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
