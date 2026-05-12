//
//  MacPopup.swift
//  DesignSystem
//
//  Created by 이승진 on 5/12/26.
//

#if os(macOS)
import SwiftUI

/// macOS 팝업 메뉴 컨테이너입니다.
///
/// 위 row는 기본 액션(`normal`), 아래 row는 위험 액션(`danger`)으로 표시합니다.
///
/// ```swift
/// MacPopup(
///   normalImage: Image(systemName: "square.and.pencil"),
///   normalTitle: "링크 편집하기",
///   dangerImage: Image(systemName: "trash"),
///   dangerTitle: "링크 삭제하기",
///   onNormalTap: {},
///   onDangerTap: {}
/// )
/// ```
public struct MacPopup: View {
  private let normalImage: Image
  private let normalTitle: String
  private let dangerImage: Image
  private let dangerTitle: String
  private let onNormalTap: () -> Void
  private let onDangerTap: () -> Void

  public init(
    normalImage: Image,
    normalTitle: String,
    dangerImage: Image,
    dangerTitle: String,
    onNormalTap: @escaping () -> Void,
    onDangerTap: @escaping () -> Void
  ) {
    self.normalImage = normalImage
    self.normalTitle = normalTitle
    self.dangerImage = dangerImage
    self.dangerTitle = dangerTitle
    self.onNormalTap = onNormalTap
    self.onDangerTap = onDangerTap
  }

  public var body: some View {
    VStack(spacing: 2) {
      MacPopupItem(
        image: normalImage,
        title: normalTitle,
        variant: .normal,
        onTap: onNormalTap
      )

      MacPopupItem(
        image: dangerImage,
        title: dangerTitle,
        variant: .danger,
        onTap: onDangerTap
      )
    }
    .padding(4)
    .frame(width: 168, height: 70)
    .background(Color.n0)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8)
        .strokeBorder(Color.divider2, lineWidth: 0.5)
    }
    .shadow(color: .bgShadow1, radius: 6, x: 0, y: 2)
    .shadow(color: .bgShadow2, radius: 4, x: 0, y: 2)
  }
}

#endif

#if DEBUG && os(macOS)

#Preview {
  MacPopup(
    normalImage: Image(systemName: "square.and.pencil"),
    normalTitle: "링크 편집하기",
    dangerImage: Image(systemName: "trash"),
    dangerTitle: "링크 삭제하기",
    onNormalTap: {
      print("edit")
    },
    onDangerTap: {
      print("delete")
    }
  )
  .padding()
  .background(Color.background)
}

#endif
