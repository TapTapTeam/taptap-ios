//
//  AddLinkFeature.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftData
import SwiftUI

import ComposableArchitecture

import AnalyticsKit
import Core
import DesignSystem
import Shared
import MyCategoryFeature

@Reducer
public struct AddLinkFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.analytics) var analytics
  
  @ObservableState
  public struct State: Equatable {
    var isConfirmAlertPresented = false
    var linkURL: String
    var categoryGrid = CategoryGridFeature.State(
      allowsMultipleSelection: false,
      showAllCategory: true
    )
    var selectedCategory: CategoryItem?
    var isURLExisting: Bool = false
    var articles: [ArticleItem] = []
    var showToast: Bool = false
    var toastMessage: String = ""
    var totalLinksCount: Int = 0
    var isLoading: Bool = false
    var isSheet: Bool = false
    var textFieldStyle: JNTextFieldStyle = .default
    
    public init(
      linkURL: String = ""
    ) {
      self.linkURL = linkURL
    }
  }
  
  public enum Action: Equatable {
    case onAppear
    case backGestureSwiped
    case setLinkURL(String)
    case saveButtonTapped
    case setTextFieldStyle(JNTextFieldStyle)
    case addNewCategoryButtonTapped
    case categoryGrid(CategoryGridFeature.Action)
    case confirmAlertDismissed
    case confirmAlertConfirmButtonTapped
    case saveLinkResponse(ArticleItem)
    case saveLinkResponseFailed(String)
    case checkURLExists(String)
    case didCheckURLExists(Bool)
    case showToast(String)
    case hideToast
    case fetchArticleItem
    case didFetchArticleItems([ArticleItem])
    case didFetchArticleItemsFailed(String)
    case navigateToLinkDetail(ArticleItem)
    case showArticleButtonTapped
    case setSheetPresented(Bool)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case route(AppRoute)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        analytics.track(UsageEvent.screenViewed(.addLink))
        if !UserDefaults.standard.bool(forKey: "safariInfo") {
          return .send(.setSheetPresented(true))
        }
        return .run { send in
          do {
            let articles = try swiftDataClient.link.fetchLinks()
            await send(.didFetchArticleItems(articles))
          } catch {
            await send(.didFetchArticleItemsFailed(error.localizedDescription))
          }
        }
        
      case let .setTextFieldStyle(style):
        state.textFieldStyle = style
        return .none
        
      case .showArticleButtonTapped:
        guard
          let article = state.articles.first(where: { $0.urlString == state.linkURL })
        else { return .none }
        return .send(.delegate(.route(.linkDetail(article))))
        
      case .backGestureSwiped:
        if state.linkURL.isEmpty {
          return .send(.delegate(.route(.back)))
        }
        state.isConfirmAlertPresented = true
        return .none
        
      case let .didFetchArticleItems(articles):
        state.articles = articles
        return .none
        
      case .didFetchArticleItemsFailed:
        state.toastMessage = "링크 불러오기 실패"
        state.showToast = true
        return .run { send in
          try await Task.sleep(nanoseconds: 2_000_000_000)
          await send(.hideToast)
        }
        
      case let .setLinkURL(url):
        state.linkURL = url
        return .send(.checkURLExists(url))
        
      case .saveButtonTapped:
        state.isLoading = true
        guard
          let url = URL(string: state.linkURL)
        else {
          state.isLoading = false
          return .none
        }
        
        return .run { [linkURL = state.linkURL, selectedCategory = state.selectedCategory] send in
          do {
            let metadata = try await LinkService.shared.extractMetadata(from: url)
            let newLink = ArticleItem(
              urlString: linkURL,
              title: metadata.title,
              imageURL: metadata.imageURL?.absoluteString
            )
            if selectedCategory?.categoryName == "전체" {
              newLink.category = nil
            } else {
              newLink.category = selectedCategory
            }
            try swiftDataClient.link.addLink(newLink)
            await send(.saveLinkResponse(newLink))
          } catch {
            await send(.saveLinkResponseFailed(error.localizedDescription))
          }
        }
        
      case .navigateToLinkDetail(let article):
        return .send(.delegate(.route(.linkDetail(article))))
        
      case .addNewCategoryButtonTapped:
        return .send(.delegate(.route(.addCategory)))
        
      case .categoryGrid(.delegate(.toggleCategorySelection(let category))):
        if state.selectedCategory == category {
          state.selectedCategory = nil
        } else {
          state.selectedCategory = category
        }
        return .none
        
      case .categoryGrid:
        return .none
        
      case .confirmAlertDismissed:
        state.isConfirmAlertPresented = false
        return .none
        
      case .confirmAlertConfirmButtonTapped:
        state.isConfirmAlertPresented = false
        return .send(.delegate(.route(.back)))
        
      case let .saveLinkResponse(savedArticle):
        state.isLoading = false
        analytics.track(
          ConversionEvent.linkSaved(source: .app, hasCategory: savedArticle.category != nil)
        )
        NotificationCenter.default.post(
          name: .linkSaved,
          object: savedArticle.category
        )
        return .run { [analytics] send in
          let totalCount = (try? swiftDataClient.link.fetchLinksCount(predicate: nil)) ?? -1
          analytics.setUserProperty(.savedLinkCount(totalCount))
          try await Task.sleep(nanoseconds: 2_000_000_000)
          await send(.delegate(.route(.back)))
        }
        
      case let .checkURLExists(urlString):
        return .run { send in
          do {
            let exists = try await LinkService.shared.urlExists(urlString)
            await send(.didCheckURLExists(exists))
          } catch {
            await send(.didCheckURLExists(false))
          }
        }
        
      case let .didCheckURLExists(exists):
        state.isURLExisting = exists
        if exists {
          state.toastMessage = "이미 저장된 링크입니다"
          state.showToast = true
        } else {
          state.showToast = false
        }
        return .none
        
      case .showToast(let message):
        state.toastMessage = message
        state.showToast = true
        return .run { send in
          try await Task.sleep(nanoseconds: 2_000_000_000)
          await send(.hideToast)
        }
        
      case .hideToast:
        state.showToast = false
        return .none
        
      case .fetchArticleItem:
        return .none
        
      case let .setSheetPresented(isPresented):
        state.isSheet = isPresented
        return .none
        
      case .saveLinkResponseFailed:
        return .none
      
      case .delegate:
        return .none
      }
    }
  }
  
  public init() {}
}
