# TapTap 작업 규칙

Safari에서 읽던 글에 하이라이트와 메모를 남기고 앱에 모아 두는 iOS 앱이다. 홍이 방향을 정하고 에이전트가 구현하며, 매주 한 번 릴리스한다.

## 일하는 순서

기능 작업은 spec에서 시작해 릴리스로 끝난다. spec 하나가 릴리스 하나다.

1. **spec**: `docs/specs/TEMPLATE.md` 형식으로 `docs/specs/NNN-제목.md`를 쓴다. 완료 조건은 실행해서 참과 거짓을 가를 수 있는 문장으로 쓴다.
2. **plan**: 같은 파일의 「설계」 절에 타입과 이름, 모듈 경계, 이벤트와 메시지 계약을 적는다. 홍이 이 절을 확정하면 상태를 `확정`으로 바꾸고 구현을 시작한다.
3. **구현**: `develop`에서 브랜치를 따고 논리적 변경 하나를 커밋 하나로 만든다. spec에 없는 변경이 필요해지면 spec을 먼저 고친다.
4. **검증**: 완료 조건을 하나씩 실행해 확인하고 결과를 PR 본문에 적는다. 실기기나 계정이 필요한 항목은 「홍이 확인할 것」으로 넘긴다.
5. **PR**: `develop` 대상으로 올리고 담당자를 홍으로 지정한다.
6. **릴리스**: TestFlight 업로드, 실기기 확인, 심사 제출 순서로 진행한다.

병합, 업로드, 심사 제출, 스토어 문구 변경은 홍이 지시했을 때 한다. 오타나 빌드 설정 같은 작은 수정은 spec 없이 PR로 올린다.

## 범위

- 주력은 iOS 앱(`App`, `Feature`)과 Safari 확장이다.
- macOS 앱(`TapTapMac`, `MacFeature`)은 동결했다. 공용 모듈 변경으로 맥 빌드가 깨질 때만 고친다.
- iPad 지원은 보류했고 하던 작업은 `feat/ipad-mac-layout` 브랜치에 있다.

## 빌드와 검증

Tuist가 프로젝트 파일을 만든다. 명령은 `TapTap/`에서 실행한다.

```sh
tuist install && tuist generate --no-open
xcodebuild -workspace TapTap.xcworkspace -scheme TapTap -destination 'generic/platform=iOS Simulator' build
xcodebuild -workspace TapTap.xcworkspace -scheme TapTapMac build
xcodebuild -workspace TapTap.xcworkspace -scheme AnalyticsKit -destination 'platform=iOS Simulator,name=iPhone 17' test
```

- 공용 모듈(`Core`, `Shared`, `DesignSystem`, `AnalyticsKit`)을 고치면 `TapTap`과 `TapTapMac`을 둘 다 빌드한다.
- `Tuist/Config/Project.xcconfig`와 `GoogleService-Info.plist`는 비밀값이라 git에 없다. 내용을 읽거나 출력하지 않고, 없으면 홍에게 요청한다.
- 빌드 산출물은 Xcode 기본 DerivedData에 둔다. 레포 안 경로로 지정하면 커밋에 섞인다.
- 시뮬레이터에서 실행할 빌드는 서명을 켠 채로 만든다. `CODE_SIGNING_ALLOWED=NO` 빌드는 App Group 권한이 빠져 실행 직후 죽는다.

## 코드

- 상태 변경과 부수 효과는 TCA 리듀서에 둔다.
- 설명은 커밋 메시지와 PR 본문에 쓴다. 새 코드는 주석 없이 쓰고 기존 주석은 그대로 둔다.
- 커밋 제목은 `feat:`, `fix:`, `chore:`, `docs:`, `design:`, `refactor:` 가운데 하나로 시작하고 한국어로 쓴다.
- PR 제목은 최근 병합된 PR의 형식을 따르고, 본문은 `.github/PULL_REQUEST_TEMPLATE.md`를 채운다.

## 계측

- 이벤트 정의의 정본은 `TapTap/Projects/AnalyticsKit/Sources/Event/`의 코드다. 이벤트 표 문서는 따로 두지 않는다.
- 전환 이벤트(`ConversionEvent`)는 동작이 실제로 성공한 뒤에 보낸다. 탭 시점에 보내면 실패한 시도가 전환으로 세어진다.
- 온보딩 단계 이벤트는 화면 진입 시점에 보낸다. 단계를 더하거나 순서를 바꾸면 `step_index`와 `step_name`도 같이 고친다.
- 이벤트에는 이름, 개수, 길이, 종류 같은 값만 싣는다. 검색어, 페이지 주소, 본문은 싣지 않는다.

## Safari 확장

- 스크립트는 `TapTap/Projects/App/SafariExtension/Resources/`에 있고, 번들러 없이 `manifest.json`의 `content_scripts` 순서대로 실린다. 파일을 더하면 이 목록에도 넣는다.
- 맥 확장(`MacSafariExtension`)이 같은 파일을 쓴다. 터치 경로와 마우스 경로를 함께 유지한다.
- 확장의 계측 이벤트는 `analytics.js`, `background.js`, `SafariWebExtensionHandler`, `ExtensionAnalyticsQueue` 순서로 넘어가 앱이 다음에 열릴 때 전송된다. 큐는 최근 200건만 보관한다.

## 릴리스

- 레인은 `TapTap/fastlane/fastfile`에 있다. `fastlane`을 `bundle exec` 없이 직접 실행한다. `bundle exec`로 실행하면 아카이브 단계가 실패한다.
- 인증서는 match가 `TapTapTeam/taptap-match`에서 가져온다.
