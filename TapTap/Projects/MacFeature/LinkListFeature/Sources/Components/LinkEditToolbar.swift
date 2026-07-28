//
//  LinkEditToolbar.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import SwiftUI
import DesignSystem

/// 편집하기 버튼을 눌렀을 때 보여지는 툴바입니다.
struct LinkEditToolbar: View {
  let selectedCount: Int
  let onCancel: () -> Void
  let onDelete: () -> Void
  let onMove: () -> Void
  
  var body: some View {
    ZStack {
      HStack {
        MacBackForwardButton(
          isForwardEnabled: false,
          onBackTap: onCancel,
          onForwardTap: {}
        )
        
        Spacer()
        
        HStack(spacing: 12) {
          toolbarActionButton(
            title: "삭제",
            icon: Icon.trash,
            isEnabled: selectedCount > 0,
            foreground: .danger,
            background: .bgDimDanger,
            action: onDelete
          )
          
          toolbarActionButton(
            title: "이동",
            icon: Icon.openWindow,
            isEnabled: selectedCount > 0,
            foreground: .textw,
            background: .bgBtn,
            action: onMove
          )
        }
      }
      
      Text(toolbarTitle)
        .font(.H4_SB)
        .foregroundStyle(.text1)
    }
    .padding(.leading, 20)
    .padding(.trailing, 32)
    .padding(.vertical, 20)
    .background(.n20)
    .ignoresSafeArea(edges: .top)
  }
}

private extension LinkEditToolbar {
  var toolbarTitle: String {
    selectedCount > 0 ? "\(selectedCount)개의 링크 선택됨" : "링크 편집하기"
  }
  
  func toolbarActionButton(
    title: String,
    icon: String,
    isEnabled: Bool,
    foreground: Color,
    background: Color,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      HStack(spacing: 6) {
        Image(icon: icon)
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .frame(width: 24, height: 24)
        
        Text(title)
          .font(.H4_SB)
          .padding(.horizontal, 2)
      }
      .padding(.vertical, 4)
      .padding(.horizontal, 14)
      .frame(height: 40)
      .foregroundStyle(isEnabled ? foreground : .caption2)
      .background(isEnabled ? background : .n40)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .contentShape(RoundedRectangle(cornerRadius: 12))
    }
    .buttonStyle(.plain)
    .disabled(!isEnabled)
  }
}
