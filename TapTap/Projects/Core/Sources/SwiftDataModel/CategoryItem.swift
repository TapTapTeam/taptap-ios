//
//  Category.swift
//  Domain
//
//  Created by 여성일 on 10/17/25.
//

import Foundation
import SwiftData

public struct CategoryIcon: Codable, Hashable {
  public let number: Int
  
  public init(number: Int = 1) {
    self.number = number
  }
  
  public var name: String {
    "primaryCategoryIcon\(self.number)"
  }
}

// CategoryItem은 TapTapSchema.swift에서 VersionedSchema로 정의되어 있습니다.
