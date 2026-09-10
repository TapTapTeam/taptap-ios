// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
  productTypes: [
    "ComposableArchitecture": .framework,
    "Lottie": .staticFramework,
    "AmplitudeSwift": .staticFramework,
    "Mixpanel": .staticFramework
  ]
)
#endif

let package = Package(
  name: "TapTapDependency",
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture.git",
      from: "1.10.0"
    ),
    .package(
      url: "https://github.com/airbnb/lottie-spm.git",
      from: "4.5.2"
    ),
    .package(
      url: "https://github.com/firebase/firebase-ios-sdk.git",
      from: "12.18.0"
    ),
    .package(
      url: "https://github.com/amplitude/Amplitude-Swift.git",
      from: "1.18.8"
    ),
    .package(
      url: "https://github.com/mixpanel/mixpanel-swift.git",
      from: "5.0.0"
    )
  ]
)
