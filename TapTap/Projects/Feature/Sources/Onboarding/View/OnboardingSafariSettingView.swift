//
//  OnboardingSafariSettingView.swift
//  Feature
//
//  Created by 여성일 on 1/12/26.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

struct OnboardingSafariSettingView {
  @Bindable var store: StoreOf<OnboardingSafariSettingFeature>
  
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.scenePhase) private var scenePhase
  
  @State private var currentPage: Int = 0
  @State private var pip: SimplePiPController?
}

extension OnboardingSafariSettingView: View {
  var body: some View {
    VStack(spacing: 0) {
      OnboardingSafariSetting(currentPage: $currentPage)
      .padding(.top, 60)
      Spacer()
      HStack(spacing: 8) {
        MainButton2(
          "설정하기",
          style: .soft,
          hasGradient: false
        ) {
          startPipThenOpenSetting()
        }
        .buttonStyle(.plain)

        MainButton2("다음", isDisabled: currentPage != 3) {
          store.send(.nextButtonTapped)
        }
        .buttonStyle(.plain)
      }
      .background(Color.background)
      .padding(.bottom, 8)
      .padding(.horizontal, 20)
    }
    .background(Color.background)
    .toolbar(.hidden)
    .overlay {
      if store.isAlert && !store.hasOpenedSettings {
        ZStack {
          Color.dim.ignoresSafeArea()
          AlertDialog(
            title: "Safari 권한 허용을 확인해주세요",
            subtitle: "권한을 설정하지 않으면\n제공하는 기능 사용이 제한돼요!",
            cancelTitle: "취소",
            onCancel: { store.send(.alertCancelButtonTapped) },
            buttonType: .move(title: "확인", action: { store.send(.alertConfirmButtonTapped) })
          )
          .offset(y: 4)
        }
      }
    }
    .onChange(of: scenePhase) { _, newValue in
      if newValue == .active && store.hasOpenedSettings {
        store.send(.moveToOnboardingHighlightMemo)
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

extension OnboardingSafariSettingView {
  private func startPipThenOpenSetting() {
    let videoName = (colorScheme == .dark) ? "safariSettingDark" : "safariSettingLight"
   
    guard
      let url = Bundle.main.url(forResource: videoName, withExtension: "MP4")
    else {
      print("비디오 찾을 수 없음: \(videoName)")
      return
    }
    
    if pip == nil {
      pip = SimplePiPController(url: url)
    }

    pip?.play()

    DispatchQueue.main.asyncAfter(deadline: .now()) {
      self.pip?.startPiP()

      DispatchQueue.main.asyncAfter(deadline: .now()) {
        self.openSettings()
      }
    }
  }
  
  private func openSettings() {
    if let url = URL(string: "App-prefs:SAFARI") {
      UIApplication.shared.open(url)
    }
    
    store.send(.settingsOpened)
  }
}

