//
//  OnboardingHighlightTip.swift
//  DesignSystem
//
//  Created by 홍 on 11/8/25.
//

import SwiftUI

import DesignSystem

public struct OnboardingHighlightTip {
  var visiblePinkChipLottie: Bool
  var visibleMemoChipLottie: Bool
  var onChipTapped: () -> Void
  var onMemoTapped: () -> Void
  var onPinkChipLottieCompleted: (() -> Void)?
  var onMemoChipLottieCompleted: (() -> Void)?
  
  public init(
    visiblePinkChipLottie: Bool = false,
    visibleMemoChipLottie: Bool = false,
    onChipTapped: @escaping () -> Void,
    onMemoTapped: @escaping () -> Void,
    onPinkChipLottieCompleted: (() -> Void)? = nil,
    onMemoChipLottieCompleted: (() -> Void)? = nil
  ) {
    self.visiblePinkChipLottie = visiblePinkChipLottie
    self.visibleMemoChipLottie = visibleMemoChipLottie
    self.onChipTapped = onChipTapped
    self.onMemoTapped = onMemoTapped
    self.onPinkChipLottieCompleted = onPinkChipLottieCompleted
    self.onMemoChipLottieCompleted = onMemoChipLottieCompleted
  }
}

extension OnboardingHighlightTip: View {
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 6) {
        Button(action: onChipTapped) {
          Capsule()
            .fill(.chipPink)
            .overlay(
              Capsule().strokeBorder(
                .chipPinkLine,
                lineWidth: 2
              )
            )
            .frame(width: 50, height: 40)
            .overlay {
              if visiblePinkChipLottie {
                LottieWrapperView(
                  animationName: "oneTap",
                  loopMode: .playOnce,
                  loopCount: 2,
                  bundle: .module,
                  onComplete: onPinkChipLottieCompleted
                )
                .frame(width: 92, height: 92)
              }
            }
        }
        
        Capsule()
          .fill(.chipYellow)
          .overlay(
            Capsule().strokeBorder(
              .stateDefaultLine,
              lineWidth: 2
            )
          )
          .frame(width: 50, height: 40)
        
        Capsule()
          .fill(.chipBlue)
          .overlay(
            Capsule().strokeBorder(
              .stateDefaultLine,
              lineWidth: 2
            )
          )
          .frame(width: 50, height: 40)
        
        Button(action: onMemoTapped) {
          ZStack {
            Capsule()
              .fill(Color.chipMemo)
              .overlay(
                Capsule()
                  .strokeBorder(.stateDefaultLine, lineWidth: 2)
              )
              .overlay {
                if visibleMemoChipLottie {
                  LottieWrapperView(
                    animationName: "oneTap",
                    loopMode: .playOnce,
                    bundle: .module,
                    onComplete: onMemoChipLottieCompleted
                  )
                  .frame(width: 92, height: 92)
                }
              }
            DesignSystemAsset.memo.swiftUIImage
              .resizable()
              .renderingMode(.template)
              .foregroundStyle(.chipMemoIcon)
              .frame(width: 16, height: 16)
          }
          .frame(width: 50, height: 40)
        }
      }
      .padding(.all, 4)
      .background(.stateTooltipbackground)
      .clipShape(RoundedRectangle(cornerRadius: 30))
      .shadow(color: Color.bgShadow4, radius: 3, x: 0, y: 2)
      .shadow(color: Color.bgShadow5, radius: 10, x: 0, y: 0)
    }
  }
}

#Preview {
  struct PreviewWrapper: View {
    var body: some View {
      OnboardingHighlightTip(onChipTapped: {}, onMemoTapped: {})
    }
  }
  return PreviewWrapper()
}
