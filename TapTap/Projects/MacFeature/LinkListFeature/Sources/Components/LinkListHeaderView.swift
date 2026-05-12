//
//  LinkListHeaderView.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import SwiftUI
import DesignSystem

/// 링크리스트 헤더뷰입니다.
struct LinkListHeaderView: View {
  let categoryTitle: String
  let selectedOrder: LinkListViewModel.SortOrder
  let isEditing: Bool
  let totalCount: Int
  let isAllSelected: Bool
  let onSortOrderSelect: (LinkListViewModel.SortOrder) -> Void
  let onToggleSelectAll: () -> Void
  let onEditTap: () -> Void
  
  var body: some View {
    Group {
      if isEditing {
        editHeader
      } else {
        defaultHeader
      }
    }
    .padding(.horizontal, 24)
    .padding(.top, 0)
    .padding(.bottom, 8)
  }
}

private extension LinkListHeaderView {
  var defaultHeader: some View {
    HStack(spacing: 0) {
      LinkListSortControl(
        selectedOrder: selectedOrder,
        onSelect: onSortOrderSelect
      )
      
      Spacer(minLength: 0)
      
      MacSmallCTAButton(title: "편집하기 ") {
        onEditTap()
      }
    }
  }
  
  var editHeader: some View {
    HStack(spacing: 0) {
      Text("\(categoryTitle) (\(totalCount)개)")
        .font(.B2_M)
        .foregroundStyle(.caption2)
      
      Spacer(minLength: 0)
      
      Button {
        onToggleSelectAll()
      } label: {
        Text(isAllSelected ? "모두 선택 해제" : "모두 선택")
          .font(.B2_M)
          .foregroundStyle(.caption1)
          .padding(.horizontal, 10)
          .frame(height: 28)
          .background(Color.n30)
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      .buttonStyle(.plain)
      .disabled(totalCount == 0)
    }
    .frame(height: 28)
  }
}
