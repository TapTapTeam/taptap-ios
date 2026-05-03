//
//  LinkListSortControl.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import SwiftUI
import DesignSystem

/// 링크리스트 정렬 버튼입니다.
struct LinkListSortControl: View {
  let selectedOrder: LinkListViewModel.SortOrder
  let onSelect: (LinkListViewModel.SortOrder) -> Void
  
  var body: some View {
    HStack(spacing: 5) {
      sortButton(title: "오래된순", order: .oldest)
      
      Rectangle()
        .fill(Color.divider2)
        .frame(width: 1, height: 15.5)
      
      sortButton(title: "최신순", order: .latest)
    }
  }
}

private extension LinkListSortControl {
  func sortButton(
    title: String,
    order: LinkListViewModel.SortOrder
  ) -> some View {
    Button {
      onSelect(order)
    } label: {
      Text(title)
        .font(.B2_M)
        .foregroundStyle(selectedOrder == order ? Color.caption1 : Color.caption2)
        .padding(.horizontal, 4)
        .padding(.vertical, 7)
    }
    .buttonStyle(.plain)
    .frame(height: 32)
  }
}
