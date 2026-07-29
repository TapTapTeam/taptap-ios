fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios dev

```sh
[bundle exec] fastlane ios dev
```



### ios release

```sh
[bundle exec] fastlane ios release
```



### ios beta

```sh
[bundle exec] fastlane ios beta
```

TesetFlight 업로드(버전을 입력해주세요.)

### ios appstore

```sh
[bundle exec] fastlane ios appstore
```

App Store 배포 (버전을 입력해주세요.)

### ios ci_beta

```sh
[bundle exec] fastlane ios ci_beta
```

CI용 TestFlight 업로드 (빌드 번호만 자동 업데이트)

### ios ci_release

```sh
[bundle exec] fastlane ios ci_release
```

CI용 App Store 배포 (태그 버전 사용)

----


## macos

### macos dev

```sh
[bundle exec] fastlane macos dev
```

탭탭 macOS Development 인증서/프로비저닝

### macos release

```sh
[bundle exec] fastlane macos release
```

탭탭 macOS AppStore 인증서/프로비저닝

### macos beta

```sh
[bundle exec] fastlane macos beta
```

macOS TestFlight 업로드 (버전을 입력해주세요. 예: version:1.0.0)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
