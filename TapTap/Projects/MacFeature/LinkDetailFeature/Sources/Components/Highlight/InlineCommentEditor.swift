//
//  InlineCommentEditor.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

import SwiftUI

import DesignSystem

/// 하이라이트 메모를 inline으로 작성하거나 수정하는 TextEditor입니다.
struct InlineCommentEditor: View {
  @Binding var text: String
  let onSave: () -> Void

  @FocusState private var isFocused: Bool
  @State private var isSaved: Bool = false

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Rectangle()
        .fill(Color.n20)
        .frame(height: 1)
        .padding(.horizontal, 10)

      ZStack(alignment: .topLeading) {
        if text.isEmpty && !isFocused {
          Text("하이라이트에 대한 메모를 입력해주세요")
            .font(.B2_M)
            .foregroundStyle(.caption2)
            .padding(.horizontal, 14)
            .padding(.vertical, 18)
            .allowsHitTesting(false)
        }

        TextEditor(text: $text)
          .font(.B2_M)
          .foregroundStyle(.text1)
          .focused($isFocused)
          .scrollContentBackground(.hidden)
          .frame(minHeight: 88)
          .padding(10)
          .background(Color.clear)
          .background(
            EnterKeyMonitor(isEnabled: isFocused) {
              save()
              isFocused = false
            }
          )
      }
      .background(Color.n20)
      .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    .padding(.top, 2)
    .onAppear {
      isFocused = true
    }
    .onChange(of: isFocused) { _, hasFocus in
      if !hasFocus {
        save()
      }
    }
    .onDisappear {
      save()
    }
    .onChange(of: text) { _, _ in
      isSaved = false
    }
  }

  private func save() {
    guard !isSaved else { return }
    isSaved = true
    onSave()
  }
}
