//
//  MacLargeCTAButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/29/26.
//

import SwiftUI

/// 큰 크기의 macOS용 CTA 버튼입니다.
///
/// 아이콘과 텍스트를 함께 표시하며, 버튼 variant와 상태(hover, disabled)에 따라
/// 스타일이 변경됩니다.
///
/// 주요 액션을 강조하거나, 중요한 사용자 인터랙션에 사용됩니다.
///
/// ```swift
/// MacLargeCTAButton(title: "저장") {
///   print("Tapped")
/// }
///
/// MacLargeCTAButton(title: "보관", variant: .gray) {
///   print("Tapped")
/// }
///
/// MacLargeCTAButton(title: "삭제", variant: .danger) {
///   print("Tapped")
/// }
///
/// MacLargeCTAButton(title: "닫기", variant: .white) {
///   print("Tapped")
/// }
/// .disabled(true)
/// ```
///
/// - Note:
/// Preview 환경에서는 실제 hover 이벤트를 받을 수 없으므로,
/// `debugHover(_:)`를 사용해 hover 상태를 시뮬레이션할 수 있습니다.
public struct MacLargeCTAButton: View {
  let variant: MacCTAButtonVariant
  let title: String
  let onTap: () -> Void
  
  @Environment(\.isEnabled) private var isEnabled
  @State private var isHovered = false
  
#if DEBUG
  private var debugHover: Bool?
#endif
  
  /// `MacLargeCTAButton`을 생성합니다.
  ///
  /// - Parameters:
  ///   - title: 버튼에 표시할 텍스트입니다.
  ///   - variant: 버튼의 시각적 스타일을 정의하는 variant입니다. 기본값은 `primary`입니다.
  ///   - onTap: 버튼이 탭되었을 때 실행할 액션입니다.
  public init(
    title: String,
    variant: MacCTAButtonVariant = .primary,
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
    variant: MacCTAButtonVariant = .primary,
    onTap: @escaping () -> Void,
    debugHover: Bool?
  ) {
    self.title = title
    self.variant = variant
    self.onTap = onTap
    self.debugHover = debugHover
  }
  
  public func debugHover(_ value: Bool?) -> Self {
    MacLargeCTAButton(
      title: title,
      variant: variant,
      onTap: onTap,
      debugHover: value
    )
  }
#endif
}

// MARK: - View
public extension MacLargeCTAButton {
  var body: some View {
    Button {
      onTap()
    } label: {
      HStack(spacing: 4) {
        Image(icon: Icon.bookmark)
          .resizable()
          .renderingMode(.template)
          .frame(width: 24, height: 24)
        
        Text(title)
          .font(.MAC_H4_SB)
      }
      .foregroundStyle(foregroundColor)
      .frame(width: 109, height: 48)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .contentShape(RoundedRectangle(cornerRadius: 8))
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
private extension MacLargeCTAButton {
  var effectiveHovered: Bool {
#if DEBUG
    return debugHover ?? isHovered
#else
    return isHovered
#endif
  }
  
  var backgroundColor: Color {
    switch variant {
    case .primary:
      if !isEnabled { return .n40 }
      return effectiveHovered ? .bl7 : .bgBtn
      
    case .gray:
      if !isEnabled { return .n40 }
      return effectiveHovered ? .n40 : .n30
      
    case .danger:
      if !isEnabled { return .n40 }
      return .danger
      
    case .white:
      if !isEnabled { return .n10 }
      return effectiveHovered ? .n30 : .n10
    }
  }
  
  var foregroundColor: Color {
    switch variant {
    case .primary:
      return isEnabled ? .textw : .caption2
      
    case .gray:
      return isEnabled ? .text1 : .caption2
      
    case .danger:
      return isEnabled ? .textw : .caption2
      
    case .white:
      return isEnabled ? .text1 : .caption2
    }
  }
}

// MARK: - Preview
private struct MacLargeCTAButtonPreview: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      
      // MARK: - Primary
      HStack(spacing: 12) {
        MacLargeCTAButton(title: "타이틀", variant: .primary) {
          print("Primary 기본")
        }
        
#if DEBUG
        MacLargeCTAButton(title: "타이틀", variant: .primary) {
          print("Primary hover")
        }
        .debugHover(true)
#endif
        
        MacLargeCTAButton(title: "타이틀", variant: .primary) {
          print("Primary disabled")
        }
        .disabled(true)
      }
      
      // MARK: - Gray
      HStack(spacing: 12) {
        MacLargeCTAButton(title: "타이틀", variant: .gray) {
          print("Gray 기본")
        }
        
#if DEBUG
        MacLargeCTAButton(title: "타이틀", variant: .gray) {
          print("Gray hover")
        }
        .debugHover(true)
#endif
        
        MacLargeCTAButton(title: "타이틀", variant: .gray) {
          print("Gray disabled")
        }
        .disabled(true)
      }
      
      // MARK: - Danger
      HStack(spacing: 12) {
        MacLargeCTAButton(title: "타이틀", variant: .danger) {
          print("Danger 기본")
        }
        
#if DEBUG
        MacLargeCTAButton(title: "타이틀", variant: .danger) {
          print("Danger hover")
        }
        .debugHover(true)
#endif
        
        MacLargeCTAButton(title: "타이틀", variant: .danger) {
          print("Danger disabled")
        }
        .disabled(true)
      }
      
      // MARK: - White
      HStack(spacing: 12) {
        MacLargeCTAButton(title: "타이틀", variant: .white) {
          print("White 기본")
        }
        
#if DEBUG
        MacLargeCTAButton(title: "타이틀", variant: .white) {
          print("White hover")
        }
        .debugHover(true)
#endif
        
        MacLargeCTAButton(title: "타이틀", variant: .white) {
          print("White disabled")
        }
        .disabled(true)
      }
    }
    .padding()
    .background(.black.opacity(0.3))
  }
}

#Preview {
  MacLargeCTAButtonPreview()
}
