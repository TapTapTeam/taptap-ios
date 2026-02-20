//
//  OnboardingNavigation.path.swift
//  OnboardingFeature
//
//  Created by 여성일 on 2/21/26.
//

import ComposableArchitecture

extension OnboardingFeature {
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
