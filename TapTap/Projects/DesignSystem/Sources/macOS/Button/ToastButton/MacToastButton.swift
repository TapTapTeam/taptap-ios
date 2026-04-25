//
//  MacToastButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/29/26.
//
#if os(macOS)
import SwiftUI

/// 토스트 내부에서 사용하는 macOS용 액션 버튼입니다.
///
/// 텍스트만 표시하며, hover 상태와 variant에 따라
/// 배경색 및 텍스트 색상이 변경됩니다.
///
/// 토스트의 보조 액션이나 위험 액션에 사용합니다.
///
/// ```swift
/// MacToastButton(title: "되돌리기") {
///   print("Tapped")
/// }
///
/// MacToastButton(title: "삭제", variant: .danger) {
///   print("Danger tapped")
/// }
/// ```
///
/// - Note:
/// Preview 환경에서는 실제 hover 이벤트를 받을 수 없으므로,
/// `debugHover(_:)`를 사용해 hover 상태를 시뮬레이션할 수 있습니다.
public struct MacToastButton: View {
  let variant: MacToastButtonVariant
  let title: String
  let onTap: () -> Void
  
  @State private var isHovered = false
  
#if DEBUG
  private var debugHover: Bool?
#endif
  
  /// `MacToastButton`을 생성합니다.
  ///
  /// - Parameters:
  ///   - title: 버튼에 표시할 텍스트입니다.
  ///   - variant: 버튼의 시각적 스타일을 정의하는 variant입니다. 기본값은 `primary`입니다.
  ///   - onTap: 버튼이 탭되었을 때 실행할 액션입니다.
  public init(
    title: String,
    variant: MacToastButtonVariant = .primary,
    onTap: @escaping () -> Void
  ) {
    self.title = title
    self.variant = variant
    self.onTap = onTap
#if DEBUG
    self.debugHover = nil
#endif
  }
  
#if DEBUG
  private init(
    title: String,
    variant: MacToastButtonVariant = .primary,
    onTap: @escaping () -> Void,
    debugHover: Bool?
  ) {
    self.title = title
    self.variant = variant
    self.onTap = onTap
    self.debugHover = debugHover
  }
  
  public func debugHover(_ value: Bool?) -> Self {
    MacToastButton(
      title: title,
      variant: variant,
      onTap: onTap,
      debugHover: value
    )
  }
#endif
}

// MARK: - View
public extension MacToastButton {
  var body: some View {
    Button {
      onTap()
    } label: {
      Text(title)
        .font(.B1_SB)
        .foregroundStyle(foregroundColor)
        .frame(width: 73, height: 40)
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

// MARK: - Private
private extension MacToastButton {
  var effectiveHovered: Bool {
#if DEBUG
    return debugHover ?? isHovered
#else
    return isHovered
#endif
  }
  
  var backgroundColor: Color {
    return effectiveHovered ? .n0 : .clear
  }
  
  var foregroundColor: Color {
    switch variant {
    case .primary:
      return .bl7
    case .danger:
      return .danger
    }
  }
}

// MARK: - Preview
private struct MacToastButtonPreview: View {
  var body: some View {
    VStack(spacing: 16) {
      MacToastButton(title: "타이틀") {
        print("기본 탭")
      }
      
      MacToastButton(title: "타이틀", variant: .danger) {
        print("danger 기본 탭")
      }
      
#if DEBUG
      MacToastButton(title: "타이틀") {
        print("호버 탭")
      }
      .debugHover(true)
#endif
    }
    .padding()
    .background(.black.opacity(0.3))
  }
}

#Preview {
  MacToastButtonPreview()
}
#endif
