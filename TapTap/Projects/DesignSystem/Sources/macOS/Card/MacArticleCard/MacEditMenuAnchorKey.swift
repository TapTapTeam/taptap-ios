//
//  MacEditMenuAnchorKey.swift
//  DesignSystem
//
//  Created by Claude on 8/16/26.
//

#if os(macOS)

import SwiftUI

/// 카드의 편집 버튼 위치를 상위 뷰(리스트)로 전달해, 스크롤 영역 밖에서
/// 커스텀 메뉴를 그 위치에 맞춰 그릴 수 있게 하는 PreferenceKey입니다.
public struct MacEditMenuAnchorKey: PreferenceKey {
  public static var defaultValue: Anchor<CGRect>?

  public static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
    value = nextValue() ?? value
  }
}

#endif
