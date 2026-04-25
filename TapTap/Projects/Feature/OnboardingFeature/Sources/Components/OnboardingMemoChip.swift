//
//  OnboardingMemoChip.swift
//  DesignSystem
//
//  Created by 여성일 on 1/15/26.
//

import SwiftUI

import DesignSystem

public struct OnboardingMemoChip {
  public init() {}
}

extension OnboardingMemoChip: View {
  public var body: some View {
    VStack {
      HStack {
        Text("하이라이트 문장을...")
          .lineLimit(1)
          .font(.B2_M)
          .foregroundStyle(.chipPinkLine)
        Spacer()
        DesignSystemAsset.x.swiftUIImage
          .resizable()
          .renderingMode(.template)
          .frame(width: 24, height: 24)
          .foregroundStyle(.iconGray)
      }
      .padding(.horizontal, 12)
      .frame(width: 167, height: 40)
      .background(
        Capsule()
          .fill(.chipPink)
      )
      .overlay(
        Capsule()
          .stroke(.chipPinkLine, lineWidth: 1)
      )
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)
    }
  }
}
