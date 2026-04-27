//
//  ArticleHighlightPayloadBuilder.swift
//  OriginalFeature
//
//  Created by Hong on 4/26/26.
//

import Core
import Foundation

enum ArticleHighlightPayloadBuilder {
  static func jsonString(from articleItem: ArticleItem) -> String? {
    let highlightsJSON = (articleItem.highlights ?? []).map { item in
      return [
        "id": item.id,
        "sentence": item.sentence,
        "type": item.type,
        "comments": item.comments.map { comment in
          return [
            "id": comment.id,
            "type": comment.type,
            "text": comment.text
          ]
        }
      ]
    }
    
    guard let jsonData = try? JSONSerialization.data(withJSONObject: highlightsJSON, options: []),
          let jsonString = String(data: jsonData, encoding: .utf8) else {
      return nil
    }
    
    return jsonString
  }
}
