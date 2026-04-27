//
//  SearchCategoryDropdown.swift.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/27/26.
//

import SwiftUI
import DesignSystem

public struct SearchCategoryDropdown: View {
  let items: [String]
  let selectedItem: String
  let onSelect: (String) -> Void

  public init(
    items: [String],
    selectedItem: String,
    onSelect: @escaping (String) -> Void
  ) {
    self.items = items
    self.selectedItem = selectedItem
    self.onSelect = onSelect
  }
}

extension SearchCategoryDropdown {
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(items, id: \.self) { item in
        SearchCategoryDropdownRow(
          title: item,
          isSelected: item == selectedItem,
          onTap: { onSelect(item) }
        )
      }
    }
    .frame(width: 195)
    .background(Color.n0)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .overlay {
      RoundedRectangle(cornerRadius: 16)
        .strokeBorder(Color.divider2, lineWidth: 1)
    }
    .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
  }
}

private struct SearchCategoryDropdownRow: View {
  let title: String
  let isSelected: Bool
  let onTap: () -> Void
  @State private var isHovered = false
}

extension SearchCategoryDropdownRow {
  var body: some View {
    Button(action: onTap) {
      HStack {
        Text(title)
          .font(.B2_M)
          .foregroundStyle(.caption1)
        Spacer()
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .frame(width: 195)
      .background(isHovered ? Color.bgDimHover : Color.clear)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .onHover { isHovered = $0 }
    .animation(.easeOut(duration: 0.1), value: isHovered)
  }
}
