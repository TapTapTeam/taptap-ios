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
  @State private var containerWidth: CGFloat = 1000
  
  public init(
    text: Binding<String>,
    onSearchTap: @escaping () -> Void = {},
    backForwardLeadingPadding: CGFloat = 20
  ) {
    self._text = text
    self.onSearchTap = onSearchTap
    self.backForwardLeadingPadding = backForwardLeadingPadding
  }
  
  private var searchBarWidth: CGFloat {
    let navRightEdge = backForwardLeadingPadding + 80
    let gap: CGFloat = 12
    let maxWidth = containerWidth - 2 * (navRightEdge + gap)
    return min(600, max(100, maxWidth))
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
      .frame(width: searchBarWidth)
    }
    .padding(.vertical, 20)
    .background(
      GeometryReader { geo in
        Color.clear
          .onAppear { containerWidth = geo.size.width }
          .onChange(of: geo.size.width) { _, w in containerWidth = w }
      }
    )
  }
}
#endif
