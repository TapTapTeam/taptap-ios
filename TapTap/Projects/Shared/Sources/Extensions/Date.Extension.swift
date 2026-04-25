//
//  Date + Extension.swift
//  Domain
//
//  Created by 여성일 on 10/21/25.
//

import Foundation

extension Date {
  private static let koreanDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
  }()
  
  public func formattedKoreanDate() -> String {
    return Self.koreanDateFormatter.string(from: self)
  }
}
