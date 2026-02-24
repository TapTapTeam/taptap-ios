//
//  MyCategoryCollectionFeature.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import ComposableArchitecture

import Core
import Shared

@Reducer
public struct MyCategoryCollectionFeature {
  @ObservableState
  public struct State: Equatable {
    var categoryGrid = CategoryGridFeature.State()
    var selectedCategory: CategoryItem?
    var settingModal: CategorySettingFeature.State?
    var myCategoryGrid = MyCategoryGridFeature.State()
    var allLinksCount = 0
    var showToast: Bool = false
    var toastMessage: String = ""
    
    public init() {
      print("mycategoryColl")
    }
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case settingButtonTapped
    case categoryGrid(CategoryGridFeature.Action)
    case settingModal(CategorySettingFeature.Action)
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
        
      case .myCategoryGrid(_):
        return .none
      
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
