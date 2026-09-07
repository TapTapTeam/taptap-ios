//
//  MacHoverBackground.swift
//  DesignSystem
//

#if os(macOS)

import SwiftUI

public struct MacHoverBackground<S: Shape>: ViewModifier {
  private let shape: S
  private let normal: Color
  private let hovered: Color

  @State private var isHovered: Bool = false

  public init(shape: S, normal: Color, hovered: Color) {
    self.shape = shape
    self.normal = normal
    self.hovered = hovered
  }

  public func body(content: Content) -> some View {
    content
      .background(isHovered ? hovered : normal)
      .clipShape(shape)
      .contentShape(shape)
      .onHover { isHovered = $0 }
      .animation(.easeOut(duration: 0.12), value: isHovered)
  }
}

public extension View {
  func macHoverBackground<S: Shape>(
    _ shape: S,
    normal: Color,
    hovered: Color
  ) -> some View {
    modifier(MacHoverBackground(shape: shape, normal: normal, hovered: hovered))
  }

  func macHoverBackground(
    cornerRadius: CGFloat,
    style: RoundedCornerStyle = .circular,
    normal: Color,
    hovered: Color
  ) -> some View {
    macHoverBackground(
      RoundedRectangle(cornerRadius: cornerRadius, style: style),
      normal: normal,
      hovered: hovered
    )
  }
}

#endif
