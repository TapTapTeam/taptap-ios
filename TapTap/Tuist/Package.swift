// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
  productTypes: [
    "ComposableArchitecture": .framework,
    "Lottie": .staticFramework
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
    )
  ]
)
