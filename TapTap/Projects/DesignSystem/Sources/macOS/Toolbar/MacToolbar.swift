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
  
  private var navRightEdge: CGFloat {
    backForwardLeadingPadding + 80 + 12
  }
  
  private var searchBarWidth: CGFloat {
    let available = containerWidth - navRightEdge - 20 // 오른쪽 20고정
    return min(600, max(100, available))
  }
  
  private var searchBarLeadingPadding: CGFloat {
    let centeredLeft = containerWidth / 2 - searchBarWidth / 2
    return max(navRightEdge, centeredLeft) // nav+12 이하로는 안 붙음
  }
}

public extension MacToolbar {
  var body: some View {
    ZStack(alignment: .leading) {
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
      .padding(.leading, searchBarLeadingPadding)
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
