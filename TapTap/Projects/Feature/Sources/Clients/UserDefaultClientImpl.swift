//
//  UserDefaultClientImpl.swift
//  Feature
//
//  Created by 여성일 on 1/12/26.
//

import Foundation

import ComposableArchitecture

import Domain

struct UserDefaultClientImpl: UserDefaultsClient {
  private enum UserDefaultsKey: String, CaseIterable {
    case onboarding
  }
  
  private let userDefaults: UserDefaults
  
  init(
    userDefaults: UserDefaults = .standard
  ) {
    self.userDefaults = userDefaults
  }
  
  func saveOnboardingState() {
    userDefaults.set(true, forKey: UserDefaultsKey.onboarding.rawValue)
  }
  
  func loadOnboardingState() -> Bool {
    return userDefaults.bool(forKey: UserDefaultsKey.onboarding.rawValue)
  }
}

private enum UserDefaultsClientKey: DependencyKey {
  static let liveValue: UserDefaultsClient = UserDefaultClientImpl()
}

extension DependencyValues {
  public var userDefaultsClient: UserDefaultsClient {
    get { self[UserDefaultsClientKey.self] }
    set { self[UserDefaultsClientKey.self] = newValue }
  }
}
