//
//  MacToast.swift
//  DesignSystem
//
//  Created by 여성일 on 3/29/26.
//

import SwiftUI

/// macOS용 공통 토스트 컴포넌트입니다.
///
/// 토스트의 variant에 따라 아이콘, 강조 색상, 배경색, 액션 버튼 스타일이 달라집니다.
/// 제목과 설명을 함께 표시하며, 우측에 액션 버튼과 닫기 버튼을 제공합니다.
///
/// ```swift
/// MacToast(
///   title: "링크를 삭제했어요",
///   explanation: "휴지통에서 복구할 수 있어요",
///   actionTitle: "되돌리기",
///   onActionTap: {
///     print("Action tapped")
///   },
///   onCloseTap: {
///     print("Close tapped")
///   }
/// )
///
/// MacToast(
///   variant: .danger,
///   title: "링크를 삭제했어요",
///   explanation: "이 작업은 되돌릴 수 없어요",
///   actionTitle: "확인",
///   onActionTap: {
///     print("Action tapped")
///   },
///   onCloseTap: {
///     print("Close tapped")
///   }
/// )
/// ```
public struct MacToast: View {
  let variant: MacToastVariant
  let title: String
  let explanation: String
  let actionTitle: String
  let onActionTap: () -> Void
  let onCloseTap: () -> Void
  
  /// `MacToast`를 생성합니다.
  ///
  /// - Parameters:
  ///   - variant: 토스트의 시각적 스타일을 정의하는 variant입니다. 기본값은 `primary`입니다.
  ///   - title: 토스트의 주요 메시지입니다.
  ///   - explanation: 제목 아래에 표시할 보조 설명입니다.
  ///   - actionTitle: 우측 액션 버튼에 표시할 텍스트입니다.
  ///   - onActionTap: 액션 버튼이 탭되었을 때 실행할 액션입니다.
  ///   - onCloseTap: 닫기 버튼이 탭되었을 때 실행할 액션입니다.
  public init(
    variant: MacToastVariant = .primary,
    title: String,
    explanation: String,
    actionTitle: String,
    onActionTap: @escaping () -> Void,
    onCloseTap: @escaping () -> Void
  ) {
    self.variant = variant
    self.title = title
    self.explanation = explanation
    self.actionTitle = actionTitle
    self.onActionTap = onActionTap
    self.onCloseTap = onCloseTap
  }
}

public extension MacToast {
  var body: some View {
    HStack {
      Image(icon: icon)
        .resizable()
        .renderingMode(.template)
        .frame(width: 24, height: 24)
        .foregroundStyle(foregroundColor)
        .padding(.leading, 16)
        .padding(.trailing, 12)
      
      VStack(alignment: .leading, spacing: 2) {
        Text(title)
          .font(.MAC_B1_SB)
          .foregroundStyle(.text1)
        
        Text(explanation)
          .font(.MAC_B2_M)
          .foregroundStyle(.caption1)
      }
      
      Spacer()
      
      HStack(spacing: 0) {
        MacToastButton(
          title: actionTitle,
          variant: toastButtonVariant
        ) {
          onActionTap()
        }
        
        MacToastCloseButton {
          onCloseTap()
        }
      }
      .padding(.trailing, 16)
    }
    .frame(width: 540, height: 71)
    .background(backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .strokeBorder(foregroundColor, lineWidth: 1.5)
    )
  }
}

// MARK: - Private
private extension MacToast {
  var toastButtonVariant: MacToastButtonVariant {
    switch variant {
    case .primary:
      return .primary
    case .danger:
      return .danger
    }
  }
  
  var icon: String {
    switch variant {
    case .primary:
      return Icon.badgeCheck
    case .danger:
      return Icon.alertCircle
    }
  }
  
  var backgroundColor: Color {
    switch variant {
    case .primary:
      return .bl1
    case .danger:
      return .danger.opacity(0.12)
    }
  }
  
  var foregroundColor: Color {
    switch variant {
    case .primary:
      return .bl6
    case .danger:
      return .danger
    }
  }
}

// MARK: - Preiview
private struct MacToastPreiview: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      // MARK: - Primary
      MacToast(
        title: "Primary 타이틀",
        explanation: "설명설명설명",
        actionTitle: "되돌리기",
        onActionTap: {},
        onCloseTap: {}
      )
      
      // MARK: - Danger
      MacToast(
        variant: .danger,
        title: "Primary 타이틀",
        explanation: "설명설명설명",
        actionTitle: "되돌리기",
        onActionTap: {},
        onCloseTap: {}
      )
    }
  }
}

#Preview {
  MacToastPreiview()
}
