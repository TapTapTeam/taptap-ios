//
//  MacToastCloseButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/29/26.
//

import SwiftUI

/// 작은 크기의 macOS용 CTA 버튼입니다.
///
/// 아이콘과 텍스트를 함께 표시하며, hover 및 disabled 상태에 따라
/// 스타일이 변경됩니다.
///
/// 이 버튼은 단일 주요 액션을 수행하는 용도로 사용합니다.
///
/// ```swift
/// MacSmallCTAButton(title: "수정") {
///   print("Tapped")
/// }
///
/// MacSmallCTAButton(title: "수정") {
///   print("Tapped")
/// }
/// .disabled(true)
/// ```
///
/// - Note:
/// Preview 환경에서는 실제 hover 이벤트를 받을 수 없으므로,
/// `debugHover(_:)`를 사용해 hover 상태를 시뮬레이션할 수 있습니다.
public struct MacToastCloseButton: View {
  let onTap: () -> Void
  
  @State private var isHovered = false
  
#if DEBUG
  private var debugHover: Bool?
#endif
  
  /// `MacToastCloseButton`을 생성합니다.
  ///
  /// - Parameters:
  ///   - title: 버튼에 표시할 텍스트입니다.
  ///   - onTap: 버튼이 탭되었을 때 실행할 액션입니다.
  public init(
    onTap: @escaping () -> Void
  ) {
    self.onTap = onTap
#if DEBUG
    self.debugHover = nil
#endif
  }
  
#if DEBUG
  private init(
    onTap: @escaping () -> Void,
    debugHover: Bool?
  ) {
    self.onTap = onTap
    self.debugHover = debugHover
  }
  
  public func debugHover(_ value: Bool?) -> Self {
    MacToastCloseButton(
      onTap: onTap,
      debugHover: value
    )
  }
#endif
}

// MARK: - View
public extension MacToastCloseButton {
  var body: some View {
    Button {
      onTap()
    } label: {
      Image(icon: Icon.x)
        .resizable()
        .frame(width: 24, height: 24)
        .foregroundStyle(foregroundColor)
        .frame(width: 40, height: 40)
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
private extension MacToastCloseButton {
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
    return .icon
  }
}

// MARK: - Preview
private struct MacToastCloseButtonPreview: View {
  var body: some View {
    VStack(spacing: 16) {
      MacToastCloseButton {
        print("기본 탭")
      }
      
#if DEBUG
      MacToastCloseButton {
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
  MacToastCloseButtonPreview()
}
