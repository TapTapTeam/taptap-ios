//
//  SearchRecentRowView.swift
//  MacSearchFeature
//
//  Created by 여성일 on 5/11/26.
//

import SwiftUI
import DesignSystem

public struct SearchRecentRowView: View {
  private let item: String
  private let onTap: (String) -> Void
  private let onDelete: (String) -> Void
  
  @State private var isHovered = false
  @State private var isDeleteHovered = false
  
  public init(
    item: String,
    onTap: @escaping (String) -> Void,
    onDelete: @escaping (String) -> Void
  ) {
    self.item = item
    self.onTap = onTap
    self.onDelete = onDelete
  }
  
  private var backgroundColor: Color {
    isHovered ? .n20 : .clear
  }
  
  private var buttonColor: Color {
    isDeleteHovered ? .icon : .iconGray
  }
}

public extension SearchRecentRowView {
  var body: some View {
    Button {
      onTap(item)
    } label: {
      HStack(spacing: 12) {
        Image(icon: Icon.history)
          .renderingMode(.template)
          .foregroundStyle(.iconDisabled)
          .frame(width: 24, height: 24)
        
        Text(item)
          .font(.B1_M)
          .foregroundStyle(.text1)
        
        Spacer()
        
        Button {
          onDelete(item)
        } label: {
          Image(icon: Icon.macX)
            .renderingMode(.template)
            .foregroundStyle(buttonColor)
            .frame(width: 24, height: 24)
        }
        .buttonStyle(.plain)
        .onHover { isDeleteHovered = $0 }
      }
      .padding(.horizontal, 20)
      .frame(height: 36)
    }
    .buttonStyle(.plain)
    .background(backgroundColor)
    .onHover { isHovered = $0 }
  }
}
