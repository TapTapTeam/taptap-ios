//
//  SafariWebExtensionHandler.swift
//  C6_Safari Extension
//
//  Created by 여성일 on 10/7/25.
//

import SafariServices
import SwiftData

#if os(iOS)
import Core
#endif

final class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
  private let appGroupID = "group.com.nbs.dev.ADA.shared"
  
  private var sharedUserDefaults: UserDefaults? {
    return UserDefaults(suiteName: appGroupID)
  }
  func beginRequest(with context: NSExtensionContext) {
    guard let item = context.inputItems.first as? NSExtensionItem else {
      context.completeRequest(returningItems: nil, completionHandler: nil)
      return
    }
    
    guard let userInfo = item.userInfo else {
      context.completeRequest(returningItems: nil, completionHandler: nil)
      return
    }
    
    guard let message = userInfo[SFExtensionMessageKey] as? [String: Any] else {
      context.completeRequest(returningItems: nil, completionHandler: nil)
      return
    }
    
    guard let action = message["action"] as? String else {
      self.sendResponse(to: context, with: ["error": "No action specified"])
      return
    }
    
    switch action {
    case "getLatestDataForURL":
      guard let url = message["url"] as? String else {
        self.sendResponse(to: context, with: ["error": "URL not provided"])
        return
      }
      
      let highlights = self.fetchHighlights(for: url) ?? []
      self.sendResponse(to: context, with: ["highlights": highlights])
      
    case "getHasShownHighlightToast":
      let hasShown = sharedUserDefaults?.bool(forKey: "hasShownHighlightToast") ?? false
      self.sendResponse(to: context, with: ["hasShownHighlightToast": hasShown])
      
    case "setHasShownHighlightToast":
      guard let value = message["value"] as? Bool else {
        self.sendResponse(to: context, with: ["error": "Value for hasShownHighlightToast not provided"])
        return
      }
      sharedUserDefaults?.set(value, forKey: "hasShownHighlightToast")
      let success = sharedUserDefaults?.synchronize() ?? false

      self.sendResponse(to: context, with: ["success": success])

    case "syncHighlights":
      guard let url = message["url"] as? String else {
        self.sendResponse(to: context, with: ["error": "URL not provided"])
        return
      }
      let title = message["title"] as? String ?? url
      let imageURL = message["imageURL"] as? String
      let drafts = message["highlights"] as? [[String: Any]] ?? []
      let synced = self.syncHighlights(url: url, title: title, imageURL: imageURL, drafts: drafts)
      self.sendResponse(to: context, with: ["success": synced])
      
    default:
      self.sendResponse(to: context, with: ["error": "Unknown action"])
    }
  }
}

// MARK: - Communication Method
private extension SafariWebExtensionHandler {
  func syncHighlights(url urlString: String, title: String, imageURL: String?, drafts: [[String: Any]]) -> Bool {
    let container = AppGroupContainer.shared
    let context = ModelContext(container)

    let thumbnailURL = (imageURL?.isEmpty == false) ? imageURL : nil
    let fetchDescriptor = FetchDescriptor<ArticleItem>(predicate: #Predicate { $0.urlString == urlString })
    let article: ArticleItem
    if let existing = try? context.fetch(fetchDescriptor).first {
      article = existing
      if article.imageURL?.isEmpty != false, let thumbnailURL {
        article.imageURL = thumbnailURL
      }
    } else {
      guard !drafts.isEmpty else { return true }
      article = ArticleItem(urlString: urlString, title: title, imageURL: thumbnailURL)
      context.insert(article)
    }

    for highlight in article.highlights ?? [] {
      context.delete(highlight)
    }

    var newHighlights: [HighlightItem] = []
    for draft in drafts {
      guard let id = draft["id"] as? String,
            let sentence = draft["text"] as? String,
            let color = draft["color"] as? String else { continue }

      let commentsArray = draft["memos"] as? [[String: Any]] ?? []
      let comments = commentsArray.compactMap { dict -> Comment? in
        guard let commentId = dict["id"] as? Double,
              let commentText = dict["text"] as? String,
              let commentType = dict["type"] as? String else { return nil }
        return Comment(id: commentId, type: commentType, text: commentText)
      }

      let newHighlight = HighlightItem(
        id: id,
        sentence: sentence,
        type: highlightType(from: color),
        createdAt: Date(),
        comments: comments
      )
      newHighlight.link = article
      context.insert(newHighlight)
      newHighlights.append(newHighlight)
    }
    article.highlights = newHighlights
    article.lastViewedDate = Date()

    do {
      try context.save()
      return true
    } catch {
      return false
    }
  }

  func highlightType(from rgba: String) -> String {
    switch rgba {
    case "rgba(255, 85, 249, 0.2)":
      return "What"
    case "rgba(255, 241, 39, 0.2)":
      return "Why"
    case "rgba(31, 180, 255, 0.2)":
      return "Detail"
    default:
      return "What"
    }
  }

  func fetchHighlights(for urlString: String) -> Any? {
    let container = AppGroupContainer.shared
    
    let context = ModelContext(container)
    
    let fetchDescriptor = FetchDescriptor<ArticleItem>(predicate: #Predicate { $0.urlString == urlString })
    
    guard let linkItem = try? context.fetch(fetchDescriptor).first else {
      return nil
    }
    
    let highlights = linkItem.highlights ?? []
    
    do {
      let encoder = JSONEncoder()
      encoder.dateEncodingStrategy = .secondsSince1970
      let jsonData = try encoder.encode(highlights)
      let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
      return jsonObject
    } catch {
      print("하이라이트 인코딩 실패: \(error)")
      return nil
    }
  }
  
  func sendResponse(to context: NSExtensionContext, with message: [String: Any]) {
    let response = NSExtensionItem()
    response.userInfo = [SFExtensionMessageKey: message]
    context.completeRequest(returningItems: [response], completionHandler: nil)
  }
}
