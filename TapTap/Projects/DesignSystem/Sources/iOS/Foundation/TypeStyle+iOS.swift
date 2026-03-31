//
//  TypeStyle+iOS.swift
//  DesignSystem
//
//  Created by 여성일 on 3/31/26.
//

#if os(iOS)
import SwiftUI
import UIKit

// MARK: - Pretendard
public extension Font {
  enum Pretendard {
    case semibold, bold, regular, medium

    var convertible: DesignSystemFontConvertible {
      switch self {
      case .semibold: DesignSystemFontFamily.Pretendard.semiBold
      case .bold: DesignSystemFontFamily.Pretendard.bold
      case .regular: DesignSystemFontFamily.Pretendard.regular
      case .medium: DesignSystemFontFamily.Pretendard.medium
      }
    }

    func uiFont(size: CGFloat) -> UIFont {
      convertible.font(size: size)
    }

    func swiftUIFont(size: CGFloat) -> Font {
      convertible.swiftUIFont(size: size)
    }
  }
}

// MARK: - View Extension
public extension View {
  func font(_ style: TypeStyle) -> some View {
    self
      .font(style.font)
      .kerning(style.letterSpacingPx)
      .lineSpacing(style.extraSpacing)
      .padding(.vertical, style.extraSpacing / 2)
  }
}

// MARK: - Presets
public extension TypeStyle {

  static let H1 = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 28),
    size: 28,
    lineHeight: 1.3,
    letterSpacing: -0.04,
    platformLineHeight: Font.Pretendard.semibold.uiFont(size: 28).lineHeight
  )

  static let H2 = TypeStyle(
    font: .Pretendard.bold.swiftUIFont(size: 24),
    size: 24,
    lineHeight: 1.3,
    letterSpacing: -0.04,
    platformLineHeight: Font.Pretendard.bold.uiFont(size: 24).lineHeight
  )

  static let H3 = TypeStyle(
    font: .Pretendard.bold.swiftUIFont(size: 20),
    size: 20,
    lineHeight: 1.4,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.bold.uiFont(size: 20).lineHeight
  )

  static let H4_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 18),
    size: 18,
    lineHeight: 1.4,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.semibold.uiFont(size: 18).lineHeight
  )

  static let H4_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 18),
    size: 18,
    lineHeight: 1.4,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.medium.uiFont(size: 18).lineHeight
  )

  static let B1_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 16),
    size: 16,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.semibold.uiFont(size: 16).lineHeight
  )

  static let B1_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 16),
    size: 16,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.medium.uiFont(size: 16).lineHeight
  )

  static let B1_M_HL = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 16),
    size: 16,
    lineHeight: 1.7,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.medium.uiFont(size: 16).lineHeight
  )

  static let B2_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.semibold.uiFont(size: 14).lineHeight
  )

  static let B2_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.medium.uiFont(size: 14).lineHeight
  )

  static let B3_R_HLM = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 16),
    size: 16,
    lineHeight: 1.7,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.regular.uiFont(size: 16).lineHeight
  )

  static let C1 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 16),
    size: 16,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.regular.uiFont(size: 16).lineHeight
  )

  static let C2 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.regular.uiFont(size: 14).lineHeight
  )

  static let C3 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 12),
    size: 12,
    lineHeight: 1.7,
    letterSpacing: 0.0,
    platformLineHeight: Font.Pretendard.regular.uiFont(size: 12).lineHeight
  )
}

public extension TypeStyle {

  // MARK: - Common Alias

  static let body2Semibold = B2_SB
  static let body2Medium = B2_M

  static let body1Medium = B1_M
  static let body1Semibold = B1_SB

  static let heading1 = H1
  static let heading2 = H2
  static let heading3 = H3
  static let heading4Semibold = H4_SB
  static let heading4Medium = H4_M

  static let caption1 = C1
  static let caption2 = C2
  static let caption3 = C3
}
#endif
