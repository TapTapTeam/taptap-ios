//
//  AppFeature.swift
//  TapTap
//
//  Created by 여성일 on 1/12/26.
//

import ComposableArchitecture

import Domain
import Feature

@Reducer
struct AppFeature {
  @ObservableState
  struct State: Equatable {
    var launchState: LaunchState = .splash
    var onboarding: OnboardingFeature.State?
    
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
    case onboarding(OnboardingFeature.Action)
    case alert(PresentationAction<Alert>)
     
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
            await send(.updateCheckResult(true))
          } catch {
            print(error)
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
        let hasCompletedOnboarding = userDefaultsClient.loadOnboardingState()
        
        if hasCompletedOnboarding {
          state.launchState = .home
          state.onboarding = nil
        } else {
          state.launchState = .onboarding
          state.onboarding = OnboardingFeature.State()
        }
        return .none
      
      case .alert(.presented(.openAppStore)):
        return .run { _ in
          await appVersionCheckClient.openAppStore()
        }
        
      case .onboarding(.delegate(.onboardingCompleted)):
        state.onboarding = nil
        state.launchState = .home
        return .none
        
      case .onboarding:
        return .none
        
      case .alert:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
    .ifLet(\.onboarding, action: \.onboarding) {
      OnboardingFeature()
    }
  }
}
