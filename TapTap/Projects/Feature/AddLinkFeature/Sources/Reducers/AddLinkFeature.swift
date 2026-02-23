//
//  AddLinkFeature.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftData
import SwiftUI

import ComposableArchitecture

import Core
import DesignSystem
import Shared
import MyCategoryFeature

@Reducer
public struct AddLinkFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
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
          //TODO: 에러 처리하기..
          return .none
        }
        
        return .run { [linkURL = state.linkURL, selectedCategory = state.selectedCategory] send in
          do {
            let title = try await extractTitle(from: url)
            let image = try await extractImageURL(from: url)
            let newLink = ArticleItem(
              urlString: linkURL,
              title: title,
              imageURL: image.absoluteString
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
        NotificationCenter.default.post(
          name: .linkSaved,
          object: savedArticle.category
        )
        return .run { send in
          try await Task.sleep(nanoseconds: 2_000_000_000)
          await send(.delegate(.route(.back)))
        }
        
      case let .checkURLExists(urlString):
        return .run { send in
          do {
            let exists = try await swiftDataClient.urlExists(urlString)
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
  
  //TODO: 함수들 어떻게 해야할지 생각해봐야함 SideEffect?
  private func extractTitle(from url: URL) async throws -> String {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let htmlString = String(data: data, encoding: .utf8) else {
      throw URLError(.cannotDecodeContentData)
    }
    
    let regex = try NSRegularExpression(pattern: "<title[^>]*>(.*?)</title>", options: [.caseInsensitive, .dotMatchesLineSeparators])
    if let match = regex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)) {
      if let titleRange = Range(match.range(at: 1), in: htmlString) {
        let title = String(htmlString[titleRange]).trimmingCharacters(in: .whitespacesAndNewlines)
        return title.decodeHtmlEntities()
      }
    }
    throw URLError(.cannotParseResponse)
  }
}

private func extractImageURL(from url: URL) async throws -> URL {
  let (data, _) = try await URLSession.shared.data(from: url)
  guard let htmlString = String(data: data, encoding: .utf8) else {
    throw URLError(.cannotDecodeContentData)
  }
  
  let ogImageRegex = try NSRegularExpression(
    pattern: "<meta[^>]*property=[\"']og:image[\"'][^>]*content=[\"']([^\"']+)[\"'][^>]*>",
    options: [.caseInsensitive, .dotMatchesLineSeparators]
  )
  if let match = ogImageRegex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)),
     let range = Range(match.range(at: 1), in: htmlString) {
    let imageUrlString = String(htmlString[range])
    if let imageUrl = URL(string: imageUrlString, relativeTo: url) {
      return imageUrl
    }
  }
  
  let imgRegex = try NSRegularExpression(
    pattern: "<img[^>]*src=[\"']([^\"']+)[\"'][^>]*>",
    options: [.caseInsensitive, .dotMatchesLineSeparators]
  )
  if let match = imgRegex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)),
     let range = Range(match.range(at: 1), in: htmlString) {
    let imageUrlString = String(htmlString[range])
    if let imageUrl = URL(string: imageUrlString, relativeTo: url) {
      return imageUrl
    }
  }
  
  throw URLError(.fileDoesNotExist)
}

extension SwiftDataClient {
  @MainActor
  func urlExists(_ urlString: String) throws -> Bool {
    let container = AppGroupContainer.shared
    let context = container.mainContext
    let fetchDescriptor = FetchDescriptor<ArticleItem>(
      predicate: #Predicate { $0.urlString == urlString }
    )
    return try context.fetch(fetchDescriptor).first != nil
  }
}
