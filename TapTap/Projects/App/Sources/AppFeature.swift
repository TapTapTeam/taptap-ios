//
//  AppFeature.swift
//  TapTap
//
//  Created by 여성일 on 1/12/26.
//

import ComposableArchitecture

import Core
import OnboardingFeature
import Shared

@Reducer
struct AppFeature {
  @ObservableState
  struct State: Equatable {
    var launchState: LaunchState = .splash
    var onboarding: OnboardingFeature.State?
    var appCoordinator: AppCoordinator.State?
    
    init() {}
    
    @Presents var alert: AlertState<Action.Alert>?
    enum LaunchState: Equatable {
      case splash
      case onboarding
      case home
    }
  }
  
  enum Action: Equatable {
    case onAppear
    case checkAppVersion
    case updateCheckResult(Bool)
    case openAppStore
    case splashFinished
    case loadOnboardingState
    case onboardingStateLoaded(Bool)
    case onboarding(OnboardingFeature.Action)
    case alert(PresentationAction<Alert>)
    case appCoordinator(AppCoordinator.Action)
    
    @CasePathable
    enum Alert: Equatable {
      case openAppStore
    }
  }
  
  @Dependency(\.userDefaultsClient) var userDefaultsClient
  @Dependency(\.appVersionCheckClient) var appVersionCheckClient
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          try await Task.sleep(for: .seconds(1.55))
          await send(.checkAppVersion)
        }
        
      case .checkAppVersion:
        return .run { send in
          do {
            let needUpdate = try await appVersionCheckClient.isUpdateAvailable()
            await send(.updateCheckResult(needUpdate))
          } catch {
            await send(.updateCheckResult(false))
          }
        }
        
      case .updateCheckResult(let result):
        if result {
          state.alert = AlertState {
            TextState("업데이트 필요")
          } actions: {
            ButtonState(action: .openAppStore) {
              TextState("업데이트하기")
            }
          } message: {
            TextState("새로운 버전이 있습니다.\n업데이트 후 다시 이용해주세요.")
          }
        } else {
          return .send(.splashFinished)
        }
        return .none
        
      case .openAppStore:
        return .none
        
      case .splashFinished:
        return .send(.loadOnboardingState)
        
      case .loadOnboardingState:
        return .run { send in
          do {
            let hasCompleted = try userDefaultsClient.loadOnboardingState()
            await send(.onboardingStateLoaded(hasCompleted))
          } catch {
            await send(.onboardingStateLoaded(false))
          }
        }
        
      case .onboarding(.delegate(.onboardingCompleted)):
        state.onboarding = nil
        if state.appCoordinator == nil {
          state.appCoordinator = .init()
        }
        state.launchState = .home
        return .none
        
      case .onboardingStateLoaded(let hasCompleted):
        if hasCompleted {
          state.onboarding = nil
          if state.appCoordinator == nil {
            state.appCoordinator = .init()
          }
          state.launchState = .home
        } else {
          state.appCoordinator = nil
          state.launchState = .onboarding
          state.onboarding = .init()
        }
        return .none
        
      case .alert(.presented(.openAppStore)):
        return .run { _ in
          await appVersionCheckClient.openAppStore()
        }
        
      case .onboarding:
        return .none
        
      case .alert:
        return .none
        
      case .appCoordinator:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
    .ifLet(\.onboarding, action: \.onboarding) { OnboardingFeature() }
    .ifLet(\.appCoordinator, action: \.appCoordinator) { AppCoordinator() }
  }
}
