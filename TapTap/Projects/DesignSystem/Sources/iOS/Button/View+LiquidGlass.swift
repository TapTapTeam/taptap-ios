//
//  View+LiquidGlass.swift
//  DesignSystem
//
//  Created by Hong on 4/23/26.
//

#if os(iOS)
import SwiftUI

public extension View {
  func liquidGlassCircle() -> some View {
    modifier(LiquidGlassCircleModifier())
  }
}

private struct LiquidGlassCircleModifier: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 26.0, *) {
      content
        .background(.clear)
        .clipShape(Circle())
        .glassEffect(.regular.interactive(), in: Circle())
    } else {
      content
        .background(.n0)
        .clipShape(Circle())
        .overlay(
          Circle()
            .stroke(.divider1, lineWidth: 1)
        )
        .shadow(color: Color(red: 0.43, green: 0.39, blue: 0.74).opacity(0.05), radius: 3, x: 0, y: 2)
        .shadow(color: Color(red: 0.24, green: 0.24, blue: 0.29).opacity(0.03), radius: 2, x: 0, y: 2)
    }
  }
}
#endif
