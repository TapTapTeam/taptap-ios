//
//  UserDefaultManager.swift
//  Domain
//
//  Created by 여성일 on 1/12/26.
//

import Foundation

public protocol UserDefaultsClient {
  func saveOnboardingState()
  func loadOnboardingState() -> Bool
}
