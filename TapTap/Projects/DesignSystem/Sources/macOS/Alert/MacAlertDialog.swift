//
//  MacAlertDialog.swift
//  DesignSystem
//
//  Created by 이승진 on 5/17/26.
//

#if os(macOS)
import SwiftUI

/// macOS에서 삭제/위험 액션을 확인할 때 사용하는 공용 알럿 다이얼로그입니다.
 ///
 /// 배경 딤 영역을 클릭하면 `onCancel`이 호출되고,
 /// destructive 버튼을 클릭하면 `onDestructive`가 호출됩니다.
 ///
 /// ```swift
 /// MacAlertDialog(
 ///   title: "이 링크를 삭제할까요?",
 ///   message: "삭제한 링크는 복구할 수 없어요",
 ///   onCancel: {
 ///     isPresented = false
 ///   },
 ///   onDestructive: {
 ///     deleteLink()
 ///   }
 /// )
 /// ```
public struct MacAlertDialog: View {
  private let title: String
  private let message: String
  private let cancelTitle: String
  private let destructiveTitle: String
  private let onCancel: () -> Void
  private let onDestructive: () -> Void

  public init(
    title: String,
    message: String,
    cancelTitle: String = "취소",
    destructiveTitle: String = "삭제",
    onCancel: @escaping () -> Void,
    onDestructive: @escaping () -> Void
  ) {
    self.title = title
    self.message = message
    self.cancelTitle = cancelTitle
    self.destructiveTitle = destructiveTitle
    self.onCancel = onCancel
    self.onDestructive = onDestructive
  }

  public var body: some View {
    ZStack {
      Color.bgDimWeb
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture(perform: onCancel)

      VStack(alignment: .leading, spacing: 0) {
        Text(title)
          .font(.B1_SB)
          .foregroundStyle(.text1)

        Text(message)
          .font(.B1_M)
          .foregroundStyle(.text1)
          .padding(.top, 10)

        Spacer(minLength: 20)

        HStack(spacing: 10) {
          Spacer()

          Button(cancelTitle, action: onCancel)
            .font(.H4_SB)
            .foregroundStyle(.text1)
            .frame(width: 72, height: 48)
            .background(.n30)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .buttonStyle(.plain)

          Button(destructiveTitle, action: onDestructive)
            .font(.H4_SB)
            .foregroundStyle(.textw)
            .frame(width: 72, height: 48)
            .background(.danger)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .buttonStyle(.plain)
        }
      }
      .padding(.horizontal, 20)
      .padding(.top, 20)
      .padding(.bottom, 20)
      .frame(width: 560, height: 160)
      .background(Color.background)
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 0)
    }
  }
}

#if DEBUG
#Preview {
  MacAlertDialog(
    title: "이 링크를 삭제할까요?",
    message: "삭제한 링크는 복구할 수 없어요",
    onCancel: {},
    onDestructive: {}
  )
}
#endif

#endif
