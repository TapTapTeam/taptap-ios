//
//  DefaultRecentSearchService.swift
//  Core
//
//  Created by 여성일 on 4/6/26.
//

import Foundation

public final class DefaultRecentSearchService: RecentSearchServicing {
  private let key = "recent_searches"
  private let maxCount = 5

  public init() {}

  public func fetch() -> [String] {
    UserDefaults.standard.stringArray(forKey: key) ?? []
  }

  public func add(_ keyword: String) {
    var items = fetch()

    items.removeAll { $0 == keyword }
    items.insert(keyword, at: 0)   

    if items.count > maxCount {
      items = Array(items.prefix(maxCount))
    }

    UserDefaults.standard.set(items, forKey: key)
  }

  public func remove(_ keyword: String) {
    var items = fetch()
    items.removeAll { $0 == keyword }
    UserDefaults.standard.set(items, forKey: key)
  }

  public func clear() {
    UserDefaults.standard.removeObject(forKey: key)
  }
}
