//
//  LinkCountFormat.swift
//  DesignSystem
//
//  Created by Hong on 8/26/26.
//

import Foundation

public extension Int {
  /// "4,009개"처럼 천 단위 구분 기호를 넣은 링크 개수 표기입니다.
  ///
  /// `Text("\(count)개")`는 `LocalizedStringKey` 보간이라 로케일 구분 기호가 붙지만,
  /// `"\(count)개"`를 String으로 먼저 만들어 넘기면 그대로 출력됩니다.
  /// 같은 개수가 화면마다 "4,009개"와 "4009개"로 갈리던 원인이라 표기를 여기서 한 번만 정합니다.
  var linkCountText: String {
    let number = Self.linkCountFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    return "\(number)개"
  }

  private static let linkCountFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    formatter.groupingSize = 3
    return formatter
  }()
}
