//
//  OnboardingCoordinator.swift
//  TapTap
//
//  Created by 여성일 on 2/24/26.
//

import ComposableArchitecture

import OnboardingFeature

@Reducer
public struct OnboardingCoordinator {
  public struct State: Equatable {
    var path = StackState<Path.State>()
    var onboarding = OnboardingFeature.State()
    
    public init() {}
  }

  public enum Action: Equatable {
    case path(StackActionOf<Path>)
    case onboarding(OnboardingFeature.Action)
    
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case completed
    }
  }

  public var body: some ReducerOf<Self> {
    Scope(state: \.onboarding, action: \.onboarding) { OnboardingFeature() }
    Reduce { state, action in
      switch action {
      case .onboarding(.delegate(.route(.onboardingSafariSetting))):
        state.path.append(.onboardingSafariSetting(.init()))
        return .none
      
      // MARK: - OnboardingSafariSetting
      case .path(.element(id: _, action: .onboardingSafariSetting(.delegate(.route(.onboardingHighlightMemo))))):
        state.path.append(.onboardingHighlightMemo(.init()))
        return .none
        
      // MARK: - OnboardingHighlightMemo
      case .path(.element(id: _, action: .onboardingHighlightMemo(.delegate(.route(.onboardingHighlightGuide))))):
        state.path.append(.onboardingHighlightGuide(.init()))
        return .none
        
      case .path(.element(id: _, action: .onboardingHighlightMemo(.delegate(.route(.onboardingShare))))):
        state.path.append(.onboardingShare(.init()))
        return .none
        
      case .path(.element(id: _, action: .onboardingHighlightMemo(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none
        
      // MARK: - OnboardingHighlightGuide
      case .path(.element(id: _, action: .onboardingHighlightGuide(.delegate(.route(.onboardingShare))))):
        state.path.append(.onboardingShare(.init()))
        return .none
      
      case .path(.element(id: _, action: .onboardingHighlightGuide(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none
        
      // MARK: - OnboardingShare
      case .path(.element(id: _, action: .onboardingShare(.delegate(.route(.onboardingShareGuide))))):
        state.path.append(.onboardingShareGuide(.init()))
        return .none
        
      case .path(.element(id: _, action: .onboardingShare(.delegate(.route(.onboardingFinish))))):
        state.path.append(.onboardingFinish(.init()))
        return .none
      
      case .path(.element(id: _, action: .onboardingShare(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none
        
      // MARK: - OnboardingShareGuide
      case .path(.element(id: _, action: .onboardingShareGuide(.delegate(.route(.onboardingFinish))))):
        state.path.append(.onboardingFinish(.init()))
        return .none
      
      case .path(.element(id: _, action: .onboardingShareGuide(.delegate(.route(.back))))):
        state.path.removeLast()
        return .none
        
      // MARK: - OnboardingFinish
      case .path(.element(id: _, action: .onboardingFinish(.delegate(.onboardingCompleted)))):
        return .send(.delegate(.completed))
      
      case .onboarding, .path, .delegate:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }

  public init() {}
}
