//
//  HighlightPopupAnchorPreferenceKey.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

import SwiftUI

/// 하이라이트 팝업의 고정 크기 값입니다.
enum HighlightPopupLayout {
  static let width: CGFloat = 168
  static let height: CGFloat = 70
}

/// 각 하이라이트/메모 항목의 bounds anchor를 상위 View로 전달합니다.
struct HighlightPopupAnchorPreferenceKey: PreferenceKey {
  static var defaultValue: [HighlightPopupTarget: Anchor<CGRect>] = [:]

  static func reduce(
    value: inout [HighlightPopupTarget: Anchor<CGRect>],
    nextValue: () -> [HighlightPopupTarget: Anchor<CGRect>]
  ) {
    value.merge(nextValue(), uniquingKeysWith: { _, next in next })
  }
}
