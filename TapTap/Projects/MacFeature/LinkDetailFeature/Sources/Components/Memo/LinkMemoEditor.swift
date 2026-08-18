//
//  LinkMemoEditor.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/11/26.
//

import SwiftUI

import DesignSystem

/// 링크에 붙는 추가 메모를 사이드 패널에서 작성하거나 수정하는 View입니다.
struct LinkMemoEditor: View {
  @Binding var text: String
  let onClose: () -> Void
  
  @FocusState private var isFocused: Bool
  @State private var isCloseButtonHovered: Bool = false

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      headerView
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .frame(height: 32)
      
      Rectangle()
        .fill(Color.n20)
        .frame(height: 1)
        .padding(.horizontal, 10)
      
      textEditor
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.n0)
    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 24))
  }
}

extension LinkMemoEditor {
  private var headerView: some View {
    HStack(spacing: 9) {
      DesignSystemAsset.macSquareEdit.swiftUIImage
        .scaledToFit()
        .frame(width: 24, height: 24)
        .padding(.leading, 10)
      
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
      .background(isCloseButtonHovered ? Color.bgDimHover : Color.clear)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .buttonStyle(.plain)
      .onHover { isCloseButtonHovered = $0 }
      .animation(.easeOut(duration: 0.12), value: isCloseButtonHovered)
    }
  }
  
  private var textEditor: some View {
    ZStack(alignment: .topLeading) {
      if text.isEmpty && !isFocused {
        Text("하이라이트에 대한 메모를 입력해주세요")
          .font(.B3_R_HLM)
          .foregroundStyle(.caption3)
          .padding(.horizontal, 12)
          .padding(.vertical, 7)
          .allowsHitTesting(false)
      }

      TextEditor(text: $text)
        .font(.B2_M)
        .foregroundStyle(.text1)
        .focused($isFocused)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.clear)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}
