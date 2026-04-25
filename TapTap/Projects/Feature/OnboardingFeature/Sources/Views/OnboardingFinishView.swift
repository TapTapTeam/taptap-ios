//
//  OnboardingFinishView.swift
//  Feature
//
//  Created by 여성일 on 1/15/26.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct OnboardingFinishView {
  public let store: StoreOf<OnboardingFinishFeature>
  
  public init(store: StoreOf<OnboardingFinishFeature>) {
    self.store = store
  }
}

extension OnboardingFinishView: View {
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 8) {
        Text("탭탭 시작하기")
          .font(.H2)
          .foregroundStyle(.text1)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)
      .padding(.top, 60)

      Text("읽고, 밑줄 긋고, 기록하며 만들어가는 시사 습관\n탭탭을 통해 만들어가요")
        .font(.C1)
        .foregroundStyle(.caption2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
        .padding(.top, 8)

      DesignSystemAsset.appStartLight.swiftUIImage
        .resizable()
        .scaledToFit()
        .padding(.horizontal, 30)
        .padding(.top, 55)
      Spacer()
      MainButton("시작하기") {
        store.send(.startButtonTapped)
      }
      .buttonStyle(.plain)
      .padding(.bottom, 8)
    }
    .toolbar(.hidden)
    .background(Color.background)
  }
}
