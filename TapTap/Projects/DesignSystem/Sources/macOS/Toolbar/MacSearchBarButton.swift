//
//  MacSearchBarButton.swift
//  DesignSystem
//
//  Created by 여성일 on 4/6/26.
//
import SwiftUI

public struct MacSearchBarButton: View {
  @Binding private var text: String
  private let onTap: () -> Void

  public init(
    text: Binding<String>,
    onTap: @escaping () -> Void
  ) {
    self._text = text
    self.onTap = onTap
  }

  public var body: some View {
    Button(action: onTap) {
      HStack(spacing: 12) {
        Image(icon: Icon.search)
          .renderingMode(.template)
          .frame(width: 24, height: 24)
          .foregroundStyle(.iconGray)

        Text(text.isEmpty ? "링크 제목으로 찾기" : text)
          .font(.B1_SB)
          .foregroundStyle(text.isEmpty ? .caption3 : .text1)

        Spacer()
      }
      .padding(.vertical, 4)
      .padding(.horizontal, 10)
      .frame(width: 600, height: 40)
      .background(.n30)
      .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .buttonStyle(.plain)
  }
}
