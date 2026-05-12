//
//  MacPopupItem.swift
//  DesignSystem
//
//  Created by 이승진 on 5/12/26.
//

#if os(macOS)
import SwiftUI

/// macOS 팝업 메뉴에서 사용하는 액션 row입니다.
///
/// 고정된 아이콘 크기와 텍스트 스타일을 사용하며,
/// hover 상태에 따라 배경색이 변경됩니다.
public struct MacPopupItem: View {
  private let variant: MacPopupVariant
  private let image: Image
  private let title: String
  private let onTap: () -> Void

  @State private var isHovered = false

#if DEBUG
  private var debugHover: Bool?
#endif

  public init(
    image: Image,
    title: String,
    variant: MacPopupVariant = .normal,
    onTap: @escaping () -> Void
  ) {
    self.variant = variant
    self.image = image
    self.title = title
    self.onTap = onTap
#if DEBUG
    self.debugHover = nil
#endif
  }

#if DEBUG
  private init(
    image: Image,
    title: String,
    variant: MacPopupVariant = .normal,
    onTap: @escaping () -> Void,
    debugHover: Bool?
  ) {
    self.variant = variant
    self.image = image
    self.title = title
    self.onTap = onTap
    self.debugHover = debugHover
  }

  /// Preview 또는 디버그 환경에서 hover 상태를 강제로 지정합니다.
  public func debugHover(_ value: Bool?) -> Self {
    MacPopupItem(
      image: image,
      title: title,
      variant: variant,
      onTap: onTap,
      debugHover: value
    )
  }
#endif

  public var body: some View {
    Button {
      onTap()
    } label: {
      HStack(spacing: 8) {
        image
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(width: 16, height: 16)
          .foregroundStyle(iconColor)

        Text(title)
          .font(.B2_M)
          .lineLimit(1)
          .foregroundStyle(textColor)

        Spacer(minLength: 0)
      }
      .padding(.horizontal, 12)
      .frame(width: 160, height: 30)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .contentShape(RoundedRectangle(cornerRadius: 8))
    }
    .buttonStyle(.plain)
    .onHover { hovering in
      isHovered = hovering
    }
    .animation(.easeOut(duration: 0.12), value: effectiveHovered)
  }
}

private extension MacPopupItem {
  var effectiveHovered: Bool {
#if DEBUG
    return debugHover ?? isHovered
#else
    return isHovered
#endif
  }

  var backgroundColor: Color {
    guard effectiveHovered else { return .clear }

    switch variant {
    case .normal:
      return .bgDimHover
    case .danger:
      return .bgDimDanger
    }
  }

  var iconColor: Color {
    switch variant {
    case .normal:
      return .iconGray
    case .danger:
      return .danger
    }
  }

  var textColor: Color {
    switch variant {
    case .normal:
      return .caption1
    case .danger:
      return .danger
    }
  }
}

#endif
