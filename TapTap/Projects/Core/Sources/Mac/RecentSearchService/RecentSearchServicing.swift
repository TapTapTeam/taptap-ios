//
//  RecentSearchServicing.swift
//  Core
//
//  Created by 여성일 on 4/6/26.
//

public protocol RecentSearchServicing {
  func fetch() -> [String]
  func add(_ keyword: String)
  func remove(_ keyword: String)
  func clear()
}
