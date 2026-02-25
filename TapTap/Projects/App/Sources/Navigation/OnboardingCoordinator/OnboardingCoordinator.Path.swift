//
//  OnboardingCoordinator.Path.swift
//  TapTap
//
//  Created by 여성일 on 2/24/26.
//

import ComposableArchitecture

import OnboardingFeature

extension OnboardingCoordinator {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case onboardingSafariSetting(OnboardingSafariSettingFeature)
    case onboardingHighlightMemo(OnboardingHighlightMemoFeature)
    case onboardingHighlightGuide(OnboardingHighlightGuideFeature)
    case onboardingShare(OnboardingShareFeature)
    case onboardingShareGuide(OnboardingShareGuideFeature)
    case onboardingFinish(OnboardingFinishFeature)
  }
}
