//
//  MacArticleCard+Style.swift
//  DesignSystem
//
//  Created by 이승진 on 4/13/26.
//

#if os(macOS)

import SwiftUI

// MARK: - Button Style
struct CardButtonStyle: ButtonStyle {
  let onPressedChange: (Bool) -> Void

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.995 : 1.0)
      .animation(.easeInOut(duration: 0.16), value: configuration.isPressed)
      .onChange(of: configuration.isPressed) { _, pressed in
        onPressedChange(pressed)
      }
  }
}

// MARK: - Visual State
extension MacArticleCard {
  enum VisualState {
    case defaultDefault
    case defaultHover
    case defaultClicked
    case editDefault
    case editHover
    case editSelected
  }

  var effectiveHovered: Bool {
    isHovered || previewHovered
  }

  var effectivePressed: Bool {
    isPressed || previewPressed
  }

  var visualState: VisualState {
    if isEditing && isSelected { return .editSelected }
    if isEditing && effectiveHovered { return .editHover }
    if isEditing { return .editDefault }
    if effectivePressed { return .defaultClicked }
    if effectiveHovered { return .defaultHover }
    return .defaultDefault
  }
}

// MARK: - Layers
extension MacArticleCard {
  var backgroundLayer: some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(.n0)
      .overlay {
        RoundedRectangle(cornerRadius: 12)
          .fill(dimColor)
      }
  }

  var borderLayer: some View {
    RoundedRectangle(cornerRadius: 12)
      .stroke(borderColor, lineWidth: borderWidth)
  }

  var dimColor: Color {
    switch visualState {
    case .defaultDefault:
      return .clear
    case .defaultHover:
      return .bgDimHover
    case .defaultClicked:
      return .bgDimWeb
    case .editDefault:
      return .clear
    case .editHover:
      return .bgDimHover
    case .editSelected:
      return .bgDimSelect
    }
  }

  var borderColor: Color {
    switch visualState {
    case .editSelected:
      return .bl6
    case .defaultHover, .editHover:
      return .clear
    default:
      return .clear
    }
  }

  var borderWidth: CGFloat {
    switch visualState {
    case .editSelected:
      return 1.5
    default:
      return 0
    }
  }

  var shouldDimImage: Bool {
    switch visualState {
    case .defaultHover, .defaultClicked, .editHover: return true
    default: return false
    }
  }

  var shadowColor: Color { .bgShadow3 }

  var shadowRadius: CGFloat { 8 }

}

#endif
