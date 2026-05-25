//
//  LinkMemoEditor.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/11/26.
//

import SwiftUI

import DesignSystem

/// 추가 메모창입니다.
struct LinkMemoEditor: View {
  @Binding var text: String
  let onSave: () -> Void
  let onClose: () -> Void
  
  @FocusState private var isFocused: Bool
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      headerView
      
      Divider()
        .background(Color.n20)
      
      textEditor
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}

extension LinkMemoEditor {
  private var headerView: some View {
    HStack(spacing: 9) {
      DesignSystemAsset.macEdit.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 24, height: 24)
      
      Text("추가 메모")
        .font(.B1_M)
        .foregroundStyle(.text1)
      
      Spacer()
      
      Button {
        isFocused = false
        onClose()
      } label: {
        DesignSystemAsset.x.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(.icon)
          .frame(width: 19, height: 19)
      }
      .frame(width: 32, height: 32)
      .buttonStyle(.plain)
    }
  }
  
  private var textEditor: some View {
    ZStack(alignment: .topLeading) {
        if text.isEmpty && !isFocused {
          Text("하이라이트에 대한 메모를 입력해주세요")
            .font(.B3_R_HLM)
            .foregroundStyle(.caption3)
            .allowsHitTesting(false)
        }

        TextEditor(text: $text)
          .font(.B2_M)
          .foregroundStyle(.text1)
          .focused($isFocused)
          .scrollContentBackground(.hidden)
          .frame(minHeight: 88)
          .background(Color.clear)
      }
      .background(Color.background)
      .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}
