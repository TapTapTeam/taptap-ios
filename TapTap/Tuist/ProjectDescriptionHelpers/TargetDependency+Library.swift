//
//  TargetDependency+Library.swift
//  Manifests
//
//  Created by Hong on 10/6/25.
//

import ProjectDescription

extension TargetDependency {
  public static func TCA() -> TargetDependency {
    .external(name: "ComposableArchitecture")
  }
  
  public static func Lottie() -> TargetDependency {
    .external(name: "Lottie")
  }
}

extension TargetDependency {
  public static func FirebaseAnalytics() -> TargetDependency {
    .external(name: Package.firebaseAnalytics)
  }

  public static func Amplitude() -> TargetDependency {
    .external(name: Package.amplitude)
  }

  public static func Mixpanel() -> TargetDependency {
    .external(name: Package.mixpanel)
  }
}
