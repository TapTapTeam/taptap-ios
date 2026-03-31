//
//  MacCTAButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/29/26.
//
#if os(macOS)
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
public struct MacSmallCTAButton: View {
  let title: String
  let onTap: () -> Void
  
  @Environment(\.isEnabled) private var isEnabled
  @State private var isHovered = false
  
#if DEBUG
  private var debugHover: Bool?
#endif
  
  
  /// `MacSmallCTAButton`을 생성합니다.
  ///
  /// - Parameters:
  ///   - title: 버튼에 표시할 텍스트입니다.
  ///   - onTap: 버튼이 탭되었을 때 실행할 액션입니다.
  public init(
    title: String,
    onTap: @escaping () -> Void
  ) {
    self.title = title
    self.onTap = onTap
#if DEBUG
    self.debugHover = nil
#endif
  }
  
#if DEBUG
  private init(
    title: String,
    onTap: @escaping () -> Void,
    debugHover: Bool?
  ) {
    self.title = title
    self.onTap = onTap
    self.debugHover = debugHover
  }
  
  public func debugHover(_ value: Bool?) -> Self {
    MacSmallCTAButton(
      title: title,
      onTap: onTap,
      debugHover: value
    )
  }
#endif
}

// MARK: - View
public extension MacSmallCTAButton {
  var body: some View {
    Button {
      onTap()
    } label: {
      HStack(spacing: 4) {
        Image(icon: Icon.edit)
          .resizable()
          .renderingMode(.template)
          .frame(width: 18, height: 18)
        
        Text(title)
          .font(.B2_M)
      }
      .foregroundStyle(foregroundColor)
      .frame(width: 73, height: 28)
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
private extension MacSmallCTAButton {
  var effectiveHovered: Bool {
#if DEBUG
    return debugHover ?? isHovered
#else
    return isHovered
#endif
  }
  
  var backgroundColor: Color {
    if !isEnabled {
      return .n20
    }
    
    return effectiveHovered ? .n40 : .n30
  }
  
  var foregroundColor: Color {
    if !isEnabled {
      return .caption3
    }
    
    return effectiveHovered ? .text1 : .caption1
  }
}

// MARK: - Preview
private struct MacSmallCTAButtonPreview: View {
  var body: some View {
    VStack(spacing: 16) {
      MacSmallCTAButton(title: "타이틀") {
        print("기본 탭")
      }
      
#if DEBUG
      MacSmallCTAButton(title: "타이틀") {
        print("호버 탭")
      }
      .debugHover(true)
#endif
      
      MacSmallCTAButton(title: "타이틀") {
        print("Disabled 탭")
      }
      .disabled(true)
    }
    .padding()
    .background(.black.opacity(0.3))
  }
}

#Preview {
  MacSmallCTAButtonPreview()
}
#endif
