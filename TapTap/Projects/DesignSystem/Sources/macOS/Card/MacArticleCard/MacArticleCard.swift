//
//  MacArticleCard.swift
//  DesignSystem
//
//  Created by 이승진 on 4/13/26.
//

#if os(macOS)

import SwiftUI

public struct MacArticleCard: View {

  // MARK: - Environment
  @Environment(\.articleCardPreviewHovered) var previewHovered
  @Environment(\.articleCardPreviewPressed) var previewPressed

  // MARK: - Properties
  let title: String
  let categoryName: String?
  let imageURL: String?
  let dateString: String
  let isEditing: Bool
  @Binding var isSelected: Bool
  let onCardTap: (() -> Void)?
  let onMoveTap: (() -> Void)?
  let onDeleteTap: (() -> Void)?

  @State var isHovered: Bool = false
  @State var isEditButtonHovered: Bool = false
  @State var showEditMenu: Bool = false
  @GestureState var isPressed: Bool = false

  // MARK: - Init
  public init(
    title: String,
    categoryName: String?,
    imageURL: String?,
    dateString: String,
    isEditing: Bool = false,
    isSelected: Binding<Bool> = .constant(false),
    onCardTap: (() -> Void)? = nil,
    onMoveTap: (() -> Void)? = nil,
    onDeleteTap: (() -> Void)? = nil
  ) {
    self.title = title
    self.categoryName = categoryName
    self.imageURL = imageURL
    self.dateString = dateString
    self.isEditing = isEditing
    self._isSelected = isSelected
    self.onCardTap = onCardTap
    self.onMoveTap = onMoveTap
    self.onDeleteTap = onDeleteTap
  }
}

// MARK: - View
extension MacArticleCard {
  public var body: some View {
    HStack(spacing: 0) {
      textContents

      Spacer(minLength: 12)

      rightContents
    }
    .frame(maxWidth: .infinity)
    .frame(height: 110)
    .background(backgroundLayer)
    .overlay(borderLayer)
    .overlay(alignment: .leading) {
      if isEditing {
        selectionIndicator
          .offset(x: -33)
          .transition(.opacity.combined(with: .scale(scale: 0.8)))
      }
    }
    .compositingGroup()
    .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 0)
    .scaleEffect(effectivePressed ? 0.995 : 1.0)
    .contentShape(RoundedRectangle(cornerRadius: 12))
    .onHover { hovered in
      isHovered = hovered
    }
    .simultaneousGesture(
      DragGesture(minimumDistance: 0)
        .updating($isPressed) { _, state, _ in
          state = true
        }
        .onEnded { _ in
          if isEditing {
            isSelected.toggle()
          } else {
            onCardTap?()
          }
        }
    )
    .animation(.easeInOut(duration: 0.16), value: visualState)
  }
}

// MARK: - Preview Environment Keys
struct ArticleCardPreviewHoveredKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

struct ArticleCardPreviewPressedKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

extension EnvironmentValues {
  var articleCardPreviewHovered: Bool {
    get { self[ArticleCardPreviewHoveredKey.self] }
    set { self[ArticleCardPreviewHoveredKey.self] = newValue }
  }

  var articleCardPreviewPressed: Bool {
    get { self[ArticleCardPreviewPressedKey.self] }
    set { self[ArticleCardPreviewPressedKey.self] = newValue }
  }
}

// MARK: - Preview Helpers
private struct ArticleCardPreviewHost: View {
  let title: String
  let categoryName: String?
  let imageURL: String?
  let dateString: String
  var isEditing: Bool = false
  var isSelected: Bool = false
  var forceHovered: Bool = false
  var forcePressed: Bool = false

  var body: some View {
    MacArticleCard(
      title: title,
      categoryName: categoryName,
      imageURL: imageURL,
      dateString: dateString,
      isEditing: isEditing,
      isSelected: .constant(isSelected)
    )
    .environment(\.articleCardPreviewHovered, forceHovered)
    .environment(\.articleCardPreviewPressed, forcePressed)
  }
}

private func previewContainer<Content: View>(
  @ViewBuilder content: () -> Content
) -> some View {
  ZStack {
    Color.gray.opacity(0.3).ignoresSafeArea()

    content()
      .frame(width: 860)
      .padding(24)
  }
  .frame(width: 940, height: 220)
}

// MARK: - Preview
#Preview("1. Normal") {
  previewContainer {
    MacArticleCard(
      title: "트럼프 \"11월 1일부터 중·대형 트럭에 25% 관세 부과\"",
      categoryName: "경제",
      imageURL: "https://images.unsplash.com/photo-1542744094-24638eff58bb",
      dateString: "2025년 10월 7일"
    )
  }
}

#Preview("2. Hovered") {
  previewContainer {
    ArticleCardPreviewHost(
      title: "트럼프 \"11월 1일부터 중·대형 트럭에 25% 관세 부과\"",
      categoryName: "경제",
      imageURL: "https://images.unsplash.com/photo-1542744094-24638eff58bb",
      dateString: "2025년 10월 7일",
      forceHovered: true
    )
  }
}

#Preview("3. Pressed") {
  previewContainer {
    ArticleCardPreviewHost(
      title: "트럼프 \"11월 1일부터 중·대형 트럭에 25% 관세 부과\"",
      categoryName: "경제",
      imageURL: "https://images.unsplash.com/photo-1542744094-24638eff58bb",
      dateString: "2025년 10월 7일",
      forcePressed: true
    )
  }
}

#Preview("4. Editing") {
  previewContainer {
    MacArticleCard(
      title: "트럼프 \"11월 1일부터 중·대형 트럭에 25% 관세 부과\"",
      categoryName: "경제",
      imageURL: "https://images.unsplash.com/photo-1542744094-24638eff58bb",
      dateString: "2025년 10월 7일",
      isEditing: true,
      isSelected: .constant(false)
    )
  }
}

#Preview("5. Editing Hovered") {
  previewContainer {
    ArticleCardPreviewHost(
      title: "트럼프 \"11월 1일부터 중·대형 트럭에 25% 관세 부과\"",
      categoryName: "경제",
      imageURL: "https://images.unsplash.com/photo-1542744094-24638eff58bb",
      dateString: "2025년 10월 7일",
      isEditing: true,
      isSelected: false,
      forceHovered: true
    )
  }
}

#Preview("6. Selected") {
  previewContainer {
    MacArticleCard(
      title: "트럼프 \"11월 1일부터 중·대형 트럭에 25% 관세 부과\"",
      categoryName: "경제",
      imageURL: "https://images.unsplash.com/photo-1542744094-24638eff58bb",
      dateString: "2025년 10월 7일",
      isEditing: true,
      isSelected: .constant(true)
    )
  }
}

#endif
