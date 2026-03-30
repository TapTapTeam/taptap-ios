//
//  MacToastCloseButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/29/26.
//

import SwiftUI

/// macOS용 토스트 닫기 버튼입니다.
///
/// `x` 아이콘을 표시하며, 사용자가 버튼을 클릭하면
/// 전달받은 `onTap` 클로저를 실행합니다.
///
/// 버튼은 hover 상태에 따라 배경색이 변경되며,
/// 토스트나 배너 우측 상단의 닫기 액션에 사용합니다.
///
/// ```swift
/// MacToastCloseButton {
///   print("Toast closed")
/// }
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
  /// - Parameter onTap: 버튼을 클릭했을 때 실행할 액션입니다.
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
