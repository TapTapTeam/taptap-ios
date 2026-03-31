//
//  MacArrowButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/29/26.
//

import SwiftUI

/// 좌우 이동에 사용하는 macOS용 화살표 버튼입니다.
///
/// 방향에 따라 아이콘과 모서리 형태가 달라지며,
/// hover 및 disabled 상태에 따라 스타일이 변경됩니다.
///
/// ```swift
/// MacArrowButton(direction: .back) {
///   print("Back")
/// }
///
/// MacArrowButton(direction: .forward) {
///   print("Forward")
/// }
/// .disabled(true)
/// ```
///
/// - Note:
/// Preview 환경에서는 실제 hover 이벤트를 받을 수 없으므로,
/// `debugHover(_:)`를 사용해 hover 상태를 시뮬레이션할 수 있습니다.
public struct MacArrowButton: View {
  let direction: MacArrowButtonDirection
  let onTap: () -> Void
  
  @Environment(\.isEnabled) private var isEnabled
  @State private var isHovered = false
  
#if DEBUG
  private var debugHover: Bool?
#endif
  
  /// `MacArrowButton`을 생성합니다.
  ///
  /// - Parameters:
  ///   - direction: 버튼의 방향입니다.
  ///   - onTap: 버튼이 탭되었을 때 실행할 액션입니다.
  public init(
    direction: MacArrowButtonDirection,
    onTap: @escaping () -> Void
  ) {
    self.direction = direction
    self.onTap = onTap
#if DEBUG
    self.debugHover = nil
#endif
  }
  
#if DEBUG
  private init(
    direction: MacArrowButtonDirection,
    onTap: @escaping () -> Void,
    debugHover: Bool?
  ) {
    self.direction = direction
    self.onTap = onTap
    self.debugHover = debugHover
  }
  
  public func debugHover(_ value: Bool?) -> Self {
    MacArrowButton(
      direction: direction,
      onTap: onTap,
      debugHover: value
    )
  }
#endif
}

// MARK: - View
public extension MacArrowButton {
  var body: some View {
    Button {
      onTap()
    } label: {
      Image(icon: icon)
        .resizable()
        .renderingMode(.template)
        .frame(width: 24, height: 24)
        .foregroundStyle(foregroundColor)
        .frame(width: 40, height: 40)
        .background(backgroundColor)
        .clipShape(buttonShape)
        .contentShape(buttonShape)
    }
    .buttonStyle(.plain)
    .onHover { hovering in
      isHovered = hovering
    }
    .animation(.easeOut(duration: 0.12), value: effectiveHovered)
    .animation(.easeOut(duration: 0.12), value: isEnabled)
  }
}

// MARK: - Private
private extension MacArrowButton {
  var effectiveHovered: Bool {
#if DEBUG
    return debugHover ?? isHovered
#else
    return isHovered
#endif
  }
  
  var icon: String {
    switch direction {
    case .back:
      return Icon.arrowLeft
    case .forward:
      return Icon.arrowRight
    }
  }
  
  var backgroundColor: Color {
    if !isEnabled {
      return .n0
    }
    
    return effectiveHovered ? .n40 : .n0
  }
  
  var foregroundColor: Color {
    if !isEnabled {
      return .iconDisabled
    }
    
    return .iconGray
  }
  
  var buttonShape: UnevenRoundedRectangle {
    switch direction {
    case .back:
      return UnevenRoundedRectangle(
        topLeadingRadius: 12,
        bottomLeadingRadius: 12,
        bottomTrailingRadius: 0,
        topTrailingRadius: 0
      )
    case .forward:
      return UnevenRoundedRectangle(
        topLeadingRadius: 0,
        bottomLeadingRadius: 0,
        bottomTrailingRadius: 12,
        topTrailingRadius: 12
      )
    }
  }
}

// MARK: - Preview
private struct MacArrowButtonPreview: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      
      // MARK: - Default
      HStack(spacing: 12) {
        MacArrowButton(direction: .back) {
          print("Back 기본")
        }
        
        MacArrowButton(direction: .forward) {
          print("Forward 기본")
        }
      }
      
      // MARK: - Hover
#if DEBUG
      HStack(spacing: 12) {
        MacArrowButton(direction: .back) {
          print("Back hover")
        }
        .debugHover(true)
        
        MacArrowButton(direction: .forward) {
          print("Forward hover")
        }
        .debugHover(true)
      }
#endif
      
      // MARK: - Disabled
      HStack(spacing: 12) {
        MacArrowButton(direction: .back) {
          print("Back disabled")
        }
        .disabled(true)
        
        MacArrowButton(direction: .forward) {
          print("Forward disabled")
        }
        .disabled(true)
      }
    }
    .padding()
    .background(.black.opacity(0.3))
  }
}

#Preview {
  MacArrowButtonPreview()
}
