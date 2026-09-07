//
//  SearchDeleteButton.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import DesignSystem

public struct SearchDeleteButton: View {
  private let action: () -> Void
  
  public init(action: @escaping () -> Void) {
    self.action = action
  }
}

public extension SearchDeleteButton {
  var body: some View {
    Button(action: action) {
      Text("전체 삭제")
        .font(.B2_M)
        .foregroundStyle(.caption1)
        .frame(width: 64, height: 28)
        .macHoverBackground(cornerRadius: 8, normal: .n30, hovered: .n40)
    }
    .buttonStyle(.plain)
  }
}
