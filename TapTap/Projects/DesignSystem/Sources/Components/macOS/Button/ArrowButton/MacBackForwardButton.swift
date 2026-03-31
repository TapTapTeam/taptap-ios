//
//  backForwardButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/29/26.
//

import SwiftUI

/// 뒤로가기와 앞으로가기 버튼을 함께 제공하는 macOS용 복합 버튼입니다.
///
/// 좌측에는 뒤로가기 버튼, 우측에는 앞으로가기 버튼이 배치되며,
/// 중앙에 divider가 포함되어 하나의 컨트롤처럼 동작합니다.
///
/// 각 버튼은 독립적으로 enabled 상태를 가질 수 있어,
/// 히스토리 이동(UIWebView, 브라우저 등)과 같은 인터랙션에 적합합니다.
///
/// ## Usage
/// ```swift
/// MacBackForwardButton(
///   onBackTap: {
///     print("Back")
///   },
///   onForwardTap: {
///     print("Forward")
///   }
/// )
///
/// MacBackForwardButton(
///   isBackEnabled: false,
///   isForwardEnabled: true,
///   onBackTap: {
///     print("Back")
///   },
///   onForwardTap: {
///     print("Forward")
///   }
/// )
/// ```
///
/// - Note:
/// 뒤로가기와 앞으로가기 버튼은 각각 독립적으로 disabled 상태를 가질 수 있습니다.
public struct MacBackForwardButton: View {
  let onBackTap: () -> Void
  let onForwardTap: () -> Void
  
  let isBackEnabled: Bool
  let isForwardEnabled: Bool
  
  /// `MacBackForwardButton`을 생성합니다.
  ///
  /// - Parameters:
  ///   - isBackEnabled: 뒤로가기 버튼의 활성화 여부입니다. 기본값은 `true`입니다.
  ///   - isForwardEnabled: 앞으로가기 버튼의 활성화 여부입니다. 기본값은 `true`입니다.
  ///   - onBackTap: 뒤로가기 버튼이 탭되었을 때 실행할 액션입니다.
  ///   - onForwardTap: 앞으로가기 버튼이 탭되었을 때 실행할 액션입니다.
  public init(
    isBackEnabled: Bool = true,
    isForwardEnabled: Bool = true,
    onBackTap: @escaping () -> Void,
    onForwardTap: @escaping () -> Void
  ) {
    self.isBackEnabled = isBackEnabled
    self.isForwardEnabled = isForwardEnabled
    self.onBackTap = onBackTap
    self.onForwardTap = onForwardTap
  }
}

// MARK: - View
public extension MacBackForwardButton {
  var body: some View {
    HStack(spacing: 0) {
      MacArrowButton(direction: .back) {
        onBackTap()
      }
      .disabled(!isBackEnabled)
      Rectangle()
        .foregroundStyle(.divider1)
        .frame(width: 0.5, height: 40)
      
      MacArrowButton(direction: .forward) {
        onForwardTap()
      }
      .disabled(!isForwardEnabled)
    }
  }
}

// MARK: - Preview
private struct MacBackForwardButtonPreview: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      MacBackForwardButton(
        onBackTap: { print("Back") },
        onForwardTap: { print("Forward") }
      )
    }
    .padding()
    .background(.black.opacity(0.3))
  }
}

#Preview {
  MacBackForwardButtonPreview()
}
