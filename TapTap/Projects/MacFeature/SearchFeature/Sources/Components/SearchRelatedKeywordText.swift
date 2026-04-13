//
//  SearchRelatedKeywordText.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import DesignSystem

public struct SearchRelatedKeywordText: View {
  private let fullText: String
  private let query: String
  
  public init(
    fullText: String,
    query: String
  ) {
    self.fullText = fullText
    self.query = query
  }
  
  public var body: some View {
    Text(highlightedText)
      .font(.B1_SB)
      .lineLimit(1)
      .frame(height: 36)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var highlightedText: AttributedString {
    var attributed = AttributedString(fullText)
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard !trimmed.isEmpty else {
      attributed.foregroundColor = .caption1
      return attributed
    }
    
    attributed.foregroundColor = .caption1
    
    if let range = attributed.range(
      of: trimmed,
      options: .caseInsensitive
    ) {
      attributed[range].foregroundColor = .bl7
    }
    
    return attributed
  }
}
