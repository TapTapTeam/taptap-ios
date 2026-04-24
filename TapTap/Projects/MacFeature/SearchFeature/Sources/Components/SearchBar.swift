//
//  SearchBar.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import DesignSystem

public struct SearchBar: View {
  @Binding private var text: String
  private let isFocused: FocusState<Bool>.Binding
  private let onSubmit: () -> Void
  
  public init(
    text: Binding<String>,
    isFocused: FocusState<Bool>.Binding,
    onSubmit: @escaping () -> Void
  ) {
    self._text = text
    self.isFocused = isFocused
    self.onSubmit = onSubmit
  }

  public var body: some View {
    ZStack(alignment: .leading) {
      if text.isEmpty {
        Text("검색어를 입력해주세요")
          .font(.B1_SB)
          .foregroundStyle(.caption3)
          .accessibilityHidden(true)
      }

      TextField("", text: $text)
        .textFieldStyle(.plain)
        .font(.B1_SB)
        .foregroundStyle(.text1)
        .focused(isFocused)
        .onSubmit {
          onSubmit()
        }
        .accessibilityLabel("검색어를 입력해주세요")
    }
    .padding(.vertical, 4)
    .padding(.horizontal, 10)
    .frame(width: 600, height: 40)
    .background(.n20)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .strokeBorder(.divider1, lineWidth: 2)
    )
  }
}
