//
//  AppVersionCheckClient.swift
//  TapTap
//
//  Created by 여성일 on 1/15/26.
//

import Foundation
import UIKit

import ComposableArchitecture

struct AppVersionCheckClient {
  var isUpdateAvailable: @Sendable () async throws -> Bool
  var openAppStore: @Sendable () async -> Void
}

extension AppVersionCheckClient: DependencyKey {
  static let liveValue: Self = {
    return Self(
      isUpdateAvailable: {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String,
              let identifier = info["CFBundleIdentifier"] as? String,
              let url = URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(identifier)")
        else {
          throw VersionError.invalidBundleInfo
        }
        print(currentVersion)
        print(identifier)
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
        
        guard let result = (json?["results"] as? [Any])?.first as? [String: Any],
              let version = result["version"] as? String
        else {
          throw VersionError.invalidResponse
        }
        
        let needUpdate = currentVersion.compare(version, options: .numeric) == .orderedAscending
        return needUpdate
      },
      openAppStore: {
        let appId = "6754357960"
        await MainActor.run {
          if let url = URL(string: "https://apps.apple.com/kr/app/\(appId)"),
             UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { _ in
              UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
              }
            }
          }
        }
      }
    )
  }()
  
  static let testValue = Self(
    isUpdateAvailable: unimplemented("AppVersionCheckClient.isUpdateAvailable"),
    openAppStore: unimplemented("AppVersionCheckClient.openAppStore")
  )
}

extension DependencyValues {
  var appVersionCheckClient: AppVersionCheckClient {
    get { self[AppVersionCheckClient.self] }
    set { self[AppVersionCheckClient.self] = newValue }
  }
}

enum VersionError: Error {
  case invalidResponse
  case invalidBundleInfo
}
