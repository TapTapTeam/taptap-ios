//
//  ArticleHighlightPayloadBuilder.swift
//  OriginalFeature
//
//  Created by Hong on 4/26/26.
//

import Core
import Foundation
 
enum ArticleHighlightPayloadBuildError: LocalizedError {
  case jsonSerializationFailed(Error)
  case stringEncodingFailed
  
  var errorDescription: String? {
    switch self {
    case .jsonSerializationFailed(let error):
      return "하이라이트 JSON 직렬화 실패: \(error.localizedDescription)"
    case .stringEncodingFailed:
      return "하이라이트 JSON 문자열 변환 실패"
    }
  }
}

enum ArticleHighlightPayloadBuilder {
  static func jsonString(from articleItem: ArticleItem) throws -> String {
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
    
    let jsonData: Data
    do {
      jsonData = try JSONSerialization.data(withJSONObject: highlightsJSON, options: [])
    } catch {
      throw ArticleHighlightPayloadBuildError.jsonSerializationFailed(error)
    }
    
    guard
      let jsonString = String(data: jsonData, encoding: .utf8)
    else {
      throw ArticleHighlightPayloadBuildError.stringEncodingFailed
    }
    
    return jsonString
  }
}
