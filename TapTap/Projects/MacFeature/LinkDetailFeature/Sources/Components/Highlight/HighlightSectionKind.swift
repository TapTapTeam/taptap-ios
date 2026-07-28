//
//  HighlightSectionKind.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/12/26.
//

import SwiftUI

import DesignSystem

/// 하이라이트 타입을 화면의 섹션 이름과 색상 토큰으로 매핑합니다.
enum HighlightSectionKind: String, CaseIterable, Identifiable {
  case pink = "what"
  case yellow = "why"
  case blue = "detail"

  var id: String { rawValue }

  var title: String {
    switch self {
    case .pink:
      return "Pink"
    case .yellow:
      return "Yellow"
    case .blue:
      return "Blue"
    }
  }

  var textColor: Color {
    switch self {
    case .pink:
      return .textWhat
    case .yellow:
      return .textWhy
    case .blue:
      return .textDetail
    }
  }

  var highlightColor: Color {
    switch self {
    case .pink:
      return .highlightWhat
    case .yellow:
      return .highlightWhy
    case .blue:
      return .highlightDetail
    }
  }

  var swatchColor: Color {
    switch self {
    case .pink:
      return .bgWhat
    case .yellow:
      return .bgWhy
    case .blue:
      return .bgDetail
    }
  }

  static func fromType(_ type: String) -> HighlightSectionKind {
    switch type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
    case "what", "pink":
      return .pink
    case "why", "yellow":
      return .yellow
    case "detail", "blue":
      return .blue
    default:
      return .blue
    }
  }
}
