//
//  TypeStyle+macOS.swift
//  DesignSystem
//
//  Created by 여성일 on 3/31/26.
//

#if os(macOS)
import SwiftUI
import AppKit

public extension Font {
  enum Pretendard {
    case semibold, bold, regular, medium

    func nsFont(size: CGFloat) -> NSFont {
      switch self {
      case .semibold:
        return NSFont(name: "Pretendard-SemiBold", size: size)
        ?? .systemFont(ofSize: size, weight: .semibold)
      case .bold:
        return NSFont(name: "Pretendard-Bold", size: size)
        ?? .boldSystemFont(ofSize: size)
      case .regular:
        return NSFont(name: "Pretendard-Regular", size: size)
        ?? .systemFont(ofSize: size)
      case .medium:
        return NSFont(name: "Pretendard-Medium", size: size)
        ?? .systemFont(ofSize: size, weight: .medium)
      }
    }

    func swiftUIFont(size: CGFloat) -> Font {
      switch self {
      case .semibold:
        return .custom("Pretendard-SemiBold", size: size)
      case .bold:
        return .custom("Pretendard-Bold", size: size)
      case .regular:
        return .custom("Pretendard-Regular", size: size)
      case .medium:
        return .custom("Pretendard-Medium", size: size)
      }
    }
  }
}

private extension Font.Pretendard {
  func lineHeight(size: CGFloat) -> CGFloat {
    let font = nsFont(size: size)
    return font.ascender - font.descender + font.leading
  }
}

public extension View {
  func font(_ style: TypeStyle) -> some View {
    self
      .font(style.font)
      .kerning(style.letterSpacingPx)
      .lineSpacing(style.extraSpacing)
      .padding(.vertical, style.extraSpacing / 2)
  }
}

public extension TypeStyle {
  // MARK: Heading
  static let H1 = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 26),
    size: 26,
    lineHeight: 1.3,
    letterSpacing: -0.04,
    platformLineHeight: Font.Pretendard.semibold.lineHeight(size: 26)
  )

  static let H2 = TypeStyle(
    font: .Pretendard.bold.swiftUIFont(size: 22),
    size: 22,
    lineHeight: 1.3,
    letterSpacing: -0.04,
    platformLineHeight: Font.Pretendard.bold.lineHeight(size: 22)
  )

  static let H3 = TypeStyle(
    font: .Pretendard.bold.swiftUIFont(size: 18),
    size: 18,
    lineHeight: 1.4,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.bold.lineHeight(size: 18)
  )

  static let H4_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 16),
    size: 16,
    lineHeight: 1.4,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.semibold.lineHeight(size: 16)
  )

  static let H4_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 16),
    size: 16,
    lineHeight: 1.4,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.medium.lineHeight(size: 16)
  )

  // MARK: Body
  static let B1_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.semibold.lineHeight(size: 14)
  )

  static let B1_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.medium.lineHeight(size: 14)
  )

  static let B1_M_HL = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 14),
    size: 14,
    lineHeight: 1.7,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.medium.lineHeight(size: 14)
  )

  static let B2_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 12),
    size: 12,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.semibold.lineHeight(size: 12)
  )

  static let B2_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 12),
    size: 12,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.medium.lineHeight(size: 12)
  )

  static let B3_R_HLM = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 14),
    size: 14,
    lineHeight: 1.7,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.regular.lineHeight(size: 14)
  )

  // MARK: Caption
  static let C1 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.regular.lineHeight(size: 14)
  )

  static let C2 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 12),
    size: 12,
    lineHeight: 1.5,
    letterSpacing: -0.02,
    platformLineHeight: Font.Pretendard.regular.lineHeight(size: 12)
  )

  static let C3 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 11),
    size: 11,
    lineHeight: 1.7,
    letterSpacing: 0.0,
    platformLineHeight: Font.Pretendard.regular.lineHeight(size: 11)
  )
}
#endif
