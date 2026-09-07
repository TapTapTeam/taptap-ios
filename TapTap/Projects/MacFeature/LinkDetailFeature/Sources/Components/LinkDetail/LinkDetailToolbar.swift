//
//  LinkDetailToolbar.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

import SwiftUI

import DesignSystem

/// 카테고리/제목 breadcrumb와 원문, 메모, 삭제 액션을 제공하는 상단 툴바입니다.
struct LinkDetailToolbar: View {
  let categoryName: String
  let categoryIconNumber: Int
  let title: String
  let onOpenOriginalLink: () -> Void
  let onOpenMemo: () -> Void
  let onDelete: () -> Void
  
  var body: some View {
    HStack(spacing: 12) {
      breadcrumb
      
      Spacer()
      
      LinkDetailToolbarButton(horizontalPadding: 14, action: onOpenOriginalLink) {
        Label {
          Text("링크 원문보기")
            .font(.B1_M)
            .foregroundStyle(.text1)
        } icon: {
          DesignSystemAsset.macLink.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(width: 16, height: 16)
        }
      }
      
      LinkDetailToolbarButton(width: 52, action: onOpenMemo) {
        DesignSystemAsset.macSquareEdit.swiftUIImage
          .foregroundStyle(.textw)
      }
      
      LinkDetailToolbarButton(width: 52, action: onDelete) {
        DesignSystemAsset.macTrashBold.swiftUIImage
          .foregroundStyle(.danger)
      }
    }
    .padding(.horizontal, 12)
    .frame(height: 60)
    .background(Color.bl1)
  }
}

private extension LinkDetailToolbar {
  var breadcrumb: some View {
    HStack(spacing: 8) {
      DesignSystemAsset.categoryIcon(number: categoryIconNumber)
        .resizable()
        .frame(width: 24, height: 24)
      
      HStack(spacing: 0) {
        Text("\(categoryName)  ")
          .font(.H4_SB)
          .foregroundStyle(.text1)
          .lineLimit(1)
        Text("/")
          .font(.H4_SB)
          .foregroundStyle(.caption3)
          .lineLimit(1)
        Text("  \(title)")
          .font(.H4_SB)
          .foregroundStyle(.text1)
          .lineLimit(1)
      }
    }
  }
}


private struct LinkDetailToolbarButton<Content: View>: View {
  var horizontalPadding: CGFloat = 0
  var width: CGFloat?
  let action: () -> Void
  @ViewBuilder let content: () -> Content

  @State private var isHovered = false

  var body: some View {
    Button(action: action) {
      content()
        .padding(.horizontal, horizontalPadding)
        .frame(width: width, height: 40)
        .background(isHovered ? Color.n40 : Color.n0)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
    }
    .buttonStyle(.plain)
    .onHover { isHovered = $0 }
    .animation(.easeOut(duration: 0.12), value: isHovered)
  }
}
