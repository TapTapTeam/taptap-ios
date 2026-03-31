//
//  TypeStyle.swift
//  DesignSystem
//
//  Created by 여성일 on 3/31/26.
//

import SwiftUI

public struct TypeStyle {
  public let font: Font
  public let size: CGFloat
  public let lineHeight: CGFloat
  public let letterSpacing: CGFloat
  let platformLineHeight: CGFloat

  public init(
    font: Font,
    size: CGFloat,
    lineHeight: CGFloat,
    letterSpacing: CGFloat,
    platformLineHeight: CGFloat
  ) {
    self.font = font
    self.size = size
    self.lineHeight = lineHeight
    self.letterSpacing = letterSpacing
    self.platformLineHeight = platformLineHeight
  }

  public var letterSpacingPx: CGFloat {
    letterSpacing * size
  }

  var extraSpacing: CGFloat {
    max((size * lineHeight) - platformLineHeight, 0)
  }
}
