//
//  OnboardingTooltipBox.swift
//  DesignSystem
//
//  Created by 홍 on 11/8/25.
//

import SwiftUI

public struct OnboardingToolTipBox {
  let text: String
  let multilineTextAlignment: TextAlignment
  
  public init(text: String, multilineTextAlignment: TextAlignment = .leading) {
    self.text = text
    self.multilineTextAlignment = multilineTextAlignment
  }
}

extension OnboardingToolTipBox: View {
  public var body: some View {
    VStack(spacing: 0) {
      
      Triangle()
        .rotation(.degrees(180))
        .fill(.bl6)
        .frame(width: 16, height: 8)
      
      Text(text)
        .font(.H4_M)
        .foregroundStyle(.textw)
        .multilineTextAlignment(multilineTextAlignment)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(.bl6)
        )
    }
  }
}

public struct OnboardingToolTipBoxBottom {
  let text: String
  let multilineTextAlignment: TextAlignment
  
  public init(text: String, multilineTextAlignment: TextAlignment = .leading) {
    self.text = text
    self.multilineTextAlignment = multilineTextAlignment
  }
}

extension OnboardingToolTipBoxBottom: View {
  public var body: some View {
    VStack(spacing: 0) {
      Text(text)
        .font(.H4_M)
        .foregroundStyle(.textw)
        .multilineTextAlignment(multilineTextAlignment)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(.bl6)
        )
      Triangle()
        .fill(.bl6)
        .frame(width: 16, height: 10)
    }
  }
}

public struct OnboardingToolTipBoxBottomTrailing {
  let text: String
  let multilineTextAlignment: TextAlignment
  
  public init(text: String, multilineTextAlignment: TextAlignment = .leading) {
    self.text = text
    self.multilineTextAlignment = multilineTextAlignment
  }
}

extension OnboardingToolTipBoxBottomTrailing: View {
  public var body: some View {
    VStack(spacing: 0) {
      Text(text)
        .font(.H4_M)
        .foregroundStyle(.textw)
        .multilineTextAlignment(multilineTextAlignment)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(.bl6)
        )
        .overlay(alignment: .bottomTrailing) {
          Triangle()
            .fill(.bl6)
            .frame(width: 18, height: 12)
            .padding(.trailing, 28)
            .padding(.bottom, -15)
        }
    }
  }
}

public struct OnboardingToolTipBoxTopLeading {
  let text: String
  let multilineTextAlignment: TextAlignment
  
  public init(text: String, multilineTextAlignment: TextAlignment = .leading) {
    self.text = text
    self.multilineTextAlignment = multilineTextAlignment
  }
}

extension OnboardingToolTipBoxTopLeading: View {
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Triangle()
        .rotation(.degrees(180))
        .fill(.bl6)
        .frame(width: 16, height: 10)
        .padding(.leading, 14)

      Text(text)
        .font(.H4_M)
        .foregroundStyle(.textw)
        .multilineTextAlignment(multilineTextAlignment)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(.bl6)
        )
    }
  }
}

#Preview {
  OnboardingToolTipBoxTopLeading(text: "g하이g하이g하이g하이g하이")
}

// MARK: - Triangle Shape
fileprivate struct Triangle: Shape {
  var cornerRadius: CGFloat = 2
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let top = CGPoint(x: rect.midX, y: rect.maxY)
    let bottomLeft = CGPoint(x: rect.minX, y: rect.minY)
    let bottomRight = CGPoint(x: rect.maxX, y: rect.minY)
    
    path.move(to: bottomLeft)
    
    path.addArc(
      tangent1End: top,
      tangent2End: bottomRight,
      radius: cornerRadius
    )
    
    path.addLine(to: bottomRight)
    path.addLine(to: bottomLeft)
    
    path.closeSubpath()
    return path
  }
}
