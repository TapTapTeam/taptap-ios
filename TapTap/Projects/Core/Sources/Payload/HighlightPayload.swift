//
//  HighlightPayload.swift
//  Feature
//
//  Created by 여성일 on 11/8/25.
//

import Foundation

public struct HighlightPayload: Decodable, Equatable {
  public let id: String
  public let sentence: String
  public let type: String
  public let comments: [Comment]
  
  public init(
    id: String,
    sentence: String,
    type: String,
    comments: [Comment]
  ) {
    self.id = id
    self.sentence = sentence
    self.type = type
    self.comments = comments
  }
}
