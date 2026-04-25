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
  
  public init(
    text: Binding<String>,
    onSearchTap: @escaping () -> Void = {}
  ) {
    self._text = text
    self.onSearchTap = onSearchTap
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
