//
//  AppFeature.swift
//  TapTap
//
//  Created by 여성일 on 1/12/26.
//

import ComposableArchitecture

import AnalyticsKit
import Core
import Shared

@Reducer
struct AppFeature {
  @ObservableState
  struct State: Equatable {
    var launchState: LaunchState = .splash

    var appCoordinator: AppCoordinator.State?
    var onboardingCoordinator: OnboardingCoordinator.State?

    @Presents var alert: AlertState<Action.Alert>?

    enum LaunchState: Equatable {
      case splash
      case onboarding
      case home
    }

    init() {}
  }

  enum Action: Equatable {
    case onAppear
    case checkAppVersion
    case updateCheckResult(Bool)
    case openAppStore
    case splashFinished
    case loadOnboardingState
    case onboardingStateLoaded(Bool)

    case appCoordinator(AppCoordinator.Action)
    case onboardingCoordinator(OnboardingCoordinator.Action)

    case alert(PresentationAction<Alert>)
    @CasePathable
    enum Alert: Equatable { case openAppStore }
  }

  @Dependency(\.userDefaultsClient) var userDefaultsClient
  @Dependency(\.appVersionCheckClient) var appVersionCheckClient
  @Dependency(\.analytics) var analytics

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
            ButtonState(action: .openAppStore) { TextState("업데이트하기") }
          } message: {
            TextState("새로운 버전이 있습니다.\n업데이트 후 다시 이용해주세요.")
          }
          return .none
        } else {
          return .send(.splashFinished)
        }

      case .alert(.presented(.openAppStore)):
        return .run { _ in
          await appVersionCheckClient.openAppStore()
        }

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

      case .onboardingStateLoaded(let hasCompleted):
        // 이번 실행에서 온보딩을 끝냈든 예전에 끝냈든 "온보딩을 마친 사람"이라는 사실은 같다.
        // 프로퍼티는 사람에 붙는 값이라 실행할 때마다 다시 세팅해도 중복이 아니다.
        analytics.setUserProperty(.hasOnboarded(hasCompleted))
        if hasCompleted {
          state.launchState = .home
          state.onboardingCoordinator = nil
          if state.appCoordinator == nil { state.appCoordinator = .init() }
        } else {
          state.launchState = .onboarding
          state.appCoordinator = nil
          if state.onboardingCoordinator == nil { state.onboardingCoordinator = .init() }
        }
        return .none

      case .onboardingCoordinator(.delegate(.completed)):
        // 전환 이벤트는 코디네이터의 완료 델리게이트에서만 찍는다.
        // 온보딩 화면을 몇 장으로 쪼개든 이 지점은 그대로라 지표가 끊기지 않는다.
        analytics.track(ConversionEvent.onboardingCompleted)
        analytics.setUserProperty(.hasOnboarded(true))
        state.launchState = .home
        state.onboardingCoordinator = nil
        if state.appCoordinator == nil { state.appCoordinator = .init() }
        return .none

      case .openAppStore:
        return .none

      case .alert:
        return .none

      case .appCoordinator:
        return .none

      case .onboardingCoordinator:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
    .ifLet(\.appCoordinator, action: \.appCoordinator) { AppCoordinator() }
    .ifLet(\.onboardingCoordinator, action: \.onboardingCoordinator) { OnboardingCoordinator() }
  }
}
