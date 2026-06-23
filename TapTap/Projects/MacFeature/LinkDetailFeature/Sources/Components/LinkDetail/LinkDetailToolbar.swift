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

      Button {
        onOpenOriginalLink()
      } label: {
        Label("링크 원문보기", systemImage: "link")
          .font(.B1_M)
          .foregroundStyle(.text1)
          .padding(.horizontal, 14)
          .frame(height: 40)
          .background(Color.n0)
          .clipShape(RoundedRectangle(cornerRadius: 12))
      }
      .buttonStyle(.plain)

      Button {
        onOpenMemo()
      } label: {
        DesignSystemAsset.macEdit.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24, height: 24)
          .foregroundStyle(.textw)
          .frame(width: 52, height: 40)
          .background(Color.n0)
          .clipShape(RoundedRectangle(cornerRadius: 12))
      }
      .buttonStyle(.plain)

      Button {
        onDelete()
      } label: {
        DesignSystemAsset.trash.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24, height: 24)
          .foregroundStyle(.danger)
          .frame(width: 52, height: 40)
          .background(Color.n0)
          .clipShape(RoundedRectangle(cornerRadius: 12))
      }
      .buttonStyle(.plain)
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

      Text("\(categoryName) / \(title)")
        .font(.B1_M)
        .foregroundStyle(.text1)
        .lineLimit(1)
    }
  }
}
