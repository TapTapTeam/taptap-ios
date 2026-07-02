//
//  MacToolbar.swift
//  DesignSystem
//
//  Created by 여성일 on 4/6/26.
//

#if os(macOS)
import SwiftUI

public struct MacToolbar: View {
  @Binding private var text: String
  private let onSearchTap: () -> Void
  private let backForwardLeadingPadding: CGFloat
  
  public init(
    text: Binding<String>,
    onSearchTap: @escaping () -> Void = {},
    backForwardLeadingPadding: CGFloat = 20
  ) {
    self._text = text
    self.onSearchTap = onSearchTap
    self.backForwardLeadingPadding = backForwardLeadingPadding
  }
}

public extension MacToolbar {
  var body: some View {
    ZStack {
      HStack {
        MacBackForwardButton(
          onBackTap: {},
          onForwardTap: {}
        )
        .padding(.leading, backForwardLeadingPadding)
        Spacer()
      }
      
      MacSearchBarButton(
        text: $text,
        onTap: onSearchTap
      )
    }
    .padding(.vertical, 20)
  }
}
#endif
