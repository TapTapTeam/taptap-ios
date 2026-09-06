//
//  SearchClearButton.swift
//  MacSearchFeature
//
//  Created by 여성일 on 8/30/26.
//

import SwiftUI
import DesignSystem

public struct SearchClearButton: View {
  private let action: () -> Void

  public init(action: @escaping () -> Void) {
    self.action = action
  }
}

public extension SearchClearButton {
  var body: some View {
    Button(action: action) {
      Image(icon: MacIcon.query_delete)
        .resizable()
        .renderingMode(.template)
        .aspectRatio(contentMode: .fit)
        .frame(width: 17.97, height: 17.97)
        .foregroundStyle(.iconDisabled)
        .frame(width: 20, height: 20)
        .macHoverBackground(Circle(), normal: .clear, hovered: .n30)
    }
    .buttonStyle(.plain)
  }
}
