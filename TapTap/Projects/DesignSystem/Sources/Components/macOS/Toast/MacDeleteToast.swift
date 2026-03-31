//
//  MacDeleteToast.swift
//  DesignSystem
//
//  Created by 여성일 on 3/29/26.
//

import SwiftUI


/// 링크 삭제 완료를 안내하는 macOS용 토스트입니다.
///
/// 삭제된 링크 제목을 표시하고,
/// 우측에 액션 버튼과 닫기 버튼을 함께 제공합니다.
///
/// 사용자는 액션 버튼으로 후속 작업을 수행할 수 있고,
/// 닫기 버튼으로 토스트를 닫을 수 있습니다.
///
/// ```swift
/// MacDeleteToast(
///   linkTitle: "테스트링크",
///   actionTitle: "되돌리기",
///   onActionTap: {
///     print("Action tapped")
///   },
///   onCloseTap: {
///     print("Close tapped")
///   }
/// )
/// ```
public struct MacDeleteToast: View {
  let linkTitle: String
  let actionTitle: String
  let onActionTap: () -> Void
  let onCloseTap: () -> Void
  
  /// `MacDeleteToast`를 생성합니다.
  ///
  /// - Parameters:
  ///   - linkTitle: 삭제된 링크의 제목입니다.
  ///   - actionTitle: 우측 액션 버튼에 표시할 텍스트입니다.
  ///   - onActionTap: 액션 버튼이 탭되었을 때 실행할 액션입니다.
  ///   - onCloseTap: 닫기 버튼이 탭되었을 때 실행할 액션입니다.
  public init(
    linkTitle: String,
    actionTitle: String,
    onActionTap: @escaping () -> Void,
    onCloseTap: @escaping () -> Void
  ) {
    self.linkTitle = linkTitle
    self.actionTitle = actionTitle
    self.onActionTap = onActionTap
    self.onCloseTap = onCloseTap
  }
}

public extension MacDeleteToast {
  var body: some View {
    HStack {
      Image(icon: Icon.badgeCheck)
        .resizable()
        .renderingMode(.template)
        .frame(width: 24, height: 24)
        .foregroundStyle(.bl6)
        .padding(.leading, 16)
        .padding(.trailing, 12)
      
      Text("'\(linkTitle)' 링크를 삭제했어요")
        .font(.MAC_B1_SB)
        .foregroundStyle(.text1)
      
      Spacer()
      
      HStack(spacing: 0) {
        MacToastButton(title: actionTitle) {
          onActionTap()
        }
        
        MacToastCloseButton {
          onCloseTap()
        }
      }
      .padding(.trailing, 16)
      
    }
    .frame(width: 540, height: 60)
    .background(.bl1)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .strokeBorder(.bl6, lineWidth: 1.5)
    )
  }
}

#Preview {
  MacDeleteToast(
    linkTitle: "테스트링크",
    actionTitle: "닫기",
    onActionTap: {},
    onCloseTap: {}
  )
}
