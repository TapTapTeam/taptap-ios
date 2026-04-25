//
//  UserDefaults.Dependency.swift
//  Shared
//
//  Created by 여성일 on 2/2/26.
//

import Foundation
import ComposableArchitecture

import Core

public struct UserDefaultsClient {
  private enum UserDefaultsKey: String, CaseIterable {
    case onboarding
  }
  
  public var saveOnboardingState: () throws -> Void
  public var loadOnboardingState: () throws -> Bool
}

extension UserDefaultsClient: DependencyKey {
  static public let liveValue: Self = {
    let userDefaults: UserDefaults = .standard
    
    return Self(
      saveOnboardingState: {
        userDefaults.set(true, forKey: UserDefaultsKey.onboarding.rawValue)
      },
      
      loadOnboardingState: {
        let state = userDefaults.bool(forKey: UserDefaultsKey.onboarding.rawValue)
        return state
      }
    )
  }()
}

extension DependencyValues {
  public var userDefaultsClient: UserDefaultsClient {
    get { self[UserDefaultsClient.self] }
    set { self[UserDefaultsClient.self] = newValue }
  }
}
