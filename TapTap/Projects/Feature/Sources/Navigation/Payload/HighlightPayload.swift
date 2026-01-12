//
//  HighlightPayload.swift
//  Feature
//
//  Created by 여성일 on 11/8/25.
//

import Foundation

import Domain

struct HighlightPayload: Decodable, Equatable {
  let id: String
  let sentence: String
  let type: String
  let comments: [Comment]
}
