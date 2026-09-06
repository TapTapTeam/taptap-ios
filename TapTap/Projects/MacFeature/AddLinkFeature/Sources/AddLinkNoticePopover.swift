//
//  AddLinkNoticePopover.swift
//  MacAddLinkFeature
//

import SwiftUI

import DesignSystem

public struct AddLinkNoticePopover: View {
  @Binding var isDontShowAgainChecked: Bool
  let onClose: () -> Void

  public init(
    isDontShowAgainChecked: Binding<Bool>,
    onClose: @escaping () -> Void
  ) {
    self._isDontShowAgainChecked = isDontShowAgainChecked
    self.onClose = onClose
  }

  public var body: some View {
    VStack(spacing: 0) {
      titleRow
        .padding(.top, 16)

      Text(subtitleText)
        .font(.system(size: 14, weight: .medium))
        .padding(.top, 10)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)

      HStack(spacing: 10) {
        guideColumn(
          label: "Safari에서 공유하기",
          labelColor: Color.bl6,
          cardBackground: Color.bl1,
          message: "하이라이트와 메모가\n모두 저장돼요",
          image: DesignSystemAsset.safariShareGuide1.swiftUIImage
        )

        guideColumn(
          label: "탭탭에서 추가하기",
          labelColor: Color.caption1,
          cardBackground: Color.n20,
          message: "하이라이트와 메모 없이\n링크 주소만 저장돼요",
          image: DesignSystemAsset.safariShareGuide2.swiftUIImage
        )
      }
      .padding(.top, 35)
      .padding(.horizontal, 20)

      dontShowAgainRow
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    .frame(width: 560)
    .background(Color.n0)
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    .shadow(color: Color.bgShadow2, radius: 8, x: 0, y: 4)
  }

  private var titleRow: some View {
    HStack(spacing: 0) {
      Text("링크 자체 추가 시 주의 사항")
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(Color.text1)
        .padding(.leading, 22)

      Spacer(minLength: 0)

      Button(action: onClose) {
        Image(icon: MacIcon.close)
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(width: 20, height: 20)
          .foregroundStyle(Color.icon)
          .frame(width: 40, height: 40)
          .macHoverBackground(cornerRadius: 8, style: .continuous, normal: .clear, hovered: .n30)
      }
      .buttonStyle(.plain)
      .accessibilityLabel("닫기")
      .padding(.trailing, 12)
    }
    .frame(height: 40)
  }

  private var subtitleText: AttributedString {
    var text = AttributedString("하이라이트와 메모를 함께 저장하기 위해 Safari에서 바로 공유를 권장해요")
    text.foregroundColor = Color.caption1

    if let range = text.range(of: "Safari") {
      text[range].foregroundColor = Color.text1
      text[range].font = .system(size: 14, weight: .semibold)
    }
    return text
  }

  private func guideColumn(
    label: String,
    labelColor: Color,
    cardBackground: Color,
    message: String,
    image: Image
  ) -> some View {
    VStack(spacing: 12) {
      Text(label)
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(labelColor)

      VStack(spacing: 0) {
        Text(message)
          .font(.system(size: 14, weight: .medium))
          .foregroundStyle(Color.text1)
          .multilineTextAlignment(.center)
          .padding(.top, 24)

        image
          .resizable()
          .scaledToFit()
          .frame(width: 132, height: 200)
          .padding(.top, 18)

        Spacer(minLength: 0)
      }
      .frame(width: 255, height: 300)
      .background(cardBackground)
      .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
  }

  private var dontShowAgainRow: some View {
    Button {
      isDontShowAgainChecked.toggle()
    } label: {
      HStack(spacing: 0) {
        ZStack {
          RoundedRectangle(cornerRadius: 4, style: .continuous)
            .strokeBorder(Color.caption2, lineWidth: 1.2)
            .frame(width: 16, height: 16)

          if isDontShowAgainChecked {
            Image(systemName: "checkmark")
              .font(.system(size: 10, weight: .bold))
              .foregroundStyle(Color.text1)
          }
        }
        .frame(width: 32, height: 32)

        Text("다시 보지 않기")
          .font(.system(size: 12, weight: .medium))
          .foregroundStyle(Color.caption1)
          .padding(.trailing, 10)
      }
      .macHoverBackground(cornerRadius: 8, style: .continuous, normal: .clear, hovered: .n20)
    }
    .buttonStyle(.plain)
    .accessibilityLabel("다시 보지 않기")
  }
}
