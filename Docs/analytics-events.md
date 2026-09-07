# 탭탭 이벤트 트래킹 정의

GA4(Firebase) · Amplitude로 **같은 이벤트를 동시에** 보낸다. 둘 다 붙이는 건 리포트를 두 벌
만들려는 게 아니라 한쪽이 죽거나 수치가 어긋날 때 교차검증하려는 것이다.

정의의 **원천은 코드**(`Projects/AnalyticsKit/Sources/Event/`)이고, 이 문서는 그걸 사람이 읽을 표로
옮긴 것이다. 이벤트를 더할 땐 코드를 먼저 고치고 이 표를 맞춘다.

## 왜 둘로 나눠 뒀나

| | `ConversionEvent` (전환) | `UsageEvent` (UI 종속) |
|---|---|---|
| 뜻 | 사용자가 "해냈다"고 볼 수 있는 행동 | 지금 화면 구성이 잘 굴러가는지 보는 사용성 지표 |
| UI를 갈아엎으면 | **이름·의미가 그대로여야 한다** | 같이 사라져도 된다 |
| 어디서 찍나 | 리듀서의 **성공 액션**에서만 | 진입·탭 액션에서 |

섞어두면 UI를 바꿀 때마다 전환 지표가 끊겨서, "개선했더니 수치가 떨어진 것"인지
"이벤트가 안 찍히는 것"인지 구분할 수 없게 된다.

버튼 탭이 아니라 성공 액션에 심는 이유도 같다. 예를 들어 `link_save`를 저장 버튼 탭에 심으면
메타데이터 추출이 실패한 경우까지 저장으로 세어진다.

## 전환 이벤트

| 이벤트 | 파라미터 | 발화 지점 | 상태 |
|---|---|---|---|
| `onboarding_complete` | — | `AppFeature` — `onboardingCoordinator(.delegate(.completed))` | ✅ |
| `link_save` | `link_source`, `has_category` | `AddLinkFeature.saveLinkResponse` | ✅ (`link_source=app`) |
| `link_open` | `link_source` | `ArticleListFeature.listCellTapped`(`app`), `SearchResultFeature.linkCardTapped`(`search`) | ✅ |
| `link_delete` | `item_count` | `DeleteLinkFeature.deleteDone` | ✅ |
| `highlight_created` | `color`, `text_length`, `surface` | 사파리 확장 `highlight.js` → 앱 그룹 큐 → 앱 실행/포그라운드에서 전송 | ✅ |
| `memo_save` | `is_edit` | `LinkDetailFeature.saveMemoSucceeded` | ✅ |
| `category_create` | `category_count` | `AddCategoryFeature.setDuplicate`(중복 아님) | ✅ |
| `link_move_category` | `item_count` | `MoveLinkFeature.moveDone` | ✅ |
| `search_submit` | `query_length`, `result_count`, `has_result` | `SearchResultFeature.searchResponse`(첫 페이지만) | ✅ |
| `link_save` (공유 시트) | `link_source=share_extension`, `has_category`, `highlight_count` | `ShareViewController` 저장 성공 → 앱 그룹 큐 | ✅ |
| `highlight_delete` | — | `HighlightEditFeature.confirmDeleteButtonTapped`(앱) · `highlight.js`(확장) | ✅ |
| `category_delete` | `item_count`(딸린 링크 수) | `DeleteCategoryFeature.confirmAlertConfirmButtonTapped` | ✅ |

`link_source` 값: `app` · `share_extension` · `safari_extension` · `search` · `widget` · `unknown`.
사파리 확장·공유 시트가 실제로 쓰이는지가 탭탭의 제품 가설 자체라 반드시 나눠 본다.

## UI 종속 이벤트

| 이벤트 | 파라미터 | 발화 지점 | 상태 |
|---|---|---|---|
| `screen_view` | `screen_name` | 각 피처 `.onAppear` | ✅ home · link_list · link_detail · add_link · search · my_category / ⬜ onboarding · original · setting (해당 화면에 `.onAppear` 액션이 없다 — 설정 하위 화면은 `setting_row_tap`으로 대신 본다) |
| `onboarding_step_view` | `step_index`, `step_name` | `OnboardingFeature`(1 intro) · `OnboardingSafariSettingFeature`(2 safari_setting) · `OnboardingHighlightGuideFeature`(3 highlight_guide) | ✅ |
| `onboarding_skip` | `step_index` | 온보딩 건너뛰기 | ⬜ 미삽입 |
| `category_favorite_toggle` | `is_favorite` | `MyCategoryCollectionFeature` 즐겨찾기 토글 | ✅ |
| `link_filter_change` | `filter` | `ArticleFilterFeature.sortOrderChanged` (`latest`/`oldest`) | ✅ |
| `recent_search_tap` | — | `SearchFeature.recentSearch(.delegate(.chipTapped))` | ✅ |
| `safari_guide_view` | — | 사파리 안내 시트 | ⬜ 미삽입 |
| `setting_row_tap` | `row` | `SettingFeature` 6개 행 (`safari_extension_tip`·`highlight_tip`·`share_tip`·`favorite_tip`·`privacy_policy`·`terms_of_service`·`open_source`·`service_open_link`) | ✅ (화면 뷰는 `.onAppear`가 없어 아직) |
| `onboarding_skip` | `step_index` | `OnboardingShareFeature`·`OnboardingHighlightMemoFeature` 건너뛰기 | ✅ |
| `safari_guide_view` | — | `ExtensionSettingFeature.naviPush` | ✅ |
| `category_edit` | `field` | `EditCategoryIconNameFeature` 아이콘 선택 | ✅ |
| `category_chip_select` | — | `CategoryChipFeature.categoryTapped` | ✅ |
| `link_edit_sheet_open` | — | `LinkListFeature` 편집 버튼·길게 누르기 | ✅ |
| `related_search_tap` | — | `SearchSuggestionFeature.suggestionTapped` | ✅ |
| `recent_link_tap` | — | `RecentLinkFeature.recentLinkTapped` | ✅ |
| `recent_search_delete` | `is_all` | `RecentSearchFeature.del`·`clear` | ✅ |
| `summary_view` | — | (미삽입 — 요약 화면 진입 액션이 없다) | ⬜ |
| `original_edit_open` | — | `OriginalArticleFeature.editButtonTapped` | ✅ |

## 사파리 확장(JS) 이벤트

확장 프로세스는 몇 백 밀리초만 살아 있어 SDK의 30초 flush를 못 돌린다. 그래서 확장은
**앱 그룹 큐에 쌓기만 하고**, 실제 전송은 앱이 켜지거나 포그라운드로 올라올 때 한다.

```
highlight.js / memo.js
  → TapTap.analytics.track(...)            analytics.js
  → browser.runtime.sendMessage            background.js
  → sendNativeMessage("trackAnalytics")    SafariWebExtensionHandler
  → ExtensionAnalyticsQueue.append         앱 그룹 UserDefaults (최대 200건)
  → ExtensionAnalyticsQueue.drain          NbsApp.deliverPendingExtensionEvents
  → AnalyticsService.track(ExtensionEvent) GA4 · Amplitude
```

브라우저용 JS SDK는 넣지 않는다. 확장 스크립트는 사용자가 방문하는 **남의 사이트**에서 도는데,
거기에 세션 리플레이나 자동 수집이 붙으면 그 페이지 내용을 우리가 가져오는 꼴이 된다.
확장에서 나가는 건 아래 표의 이벤트 이름과 값뿐이다 — 페이지 URL·본문·하이라이트 문장은 보내지 않는다.

| 이벤트 | 파라미터 | 발화 지점 |
|---|---|---|
| `highlight_created` | `color`, `text_length`, `surface` | `highlight.js` 하이라이트 저장 직후 |
| `highlight_deleted` | `surface` | `highlight.js._removeHighlightData` (실제로 지워졌을 때만) |
| `memo_saved` | `is_edit`, `text_length`, `surface` | `memo.js` 메모 저장/수정 |
| `memo_deleted` | `surface` | `memo.js.deleteMemo` |
| `highlight_synced` | `count`, `surface` | 앱으로 동기화를 보낼 때 (맥 사파리 경로) |
| `link_save` | `link_source=share_extension`, `has_category`, `highlight_count` | 공유 시트에서 저장 성공 |
| `share_category_picked` | `link_source` | 공유 시트 저장 후 카테고리를 골랐을 때 |

전송된 이벤트에는 `occurred_at`(확장에서 실제로 일어난 시각)과 `delivered_by=app_launch`가 붙는다.
큐가 200건을 넘으면 오래된 것부터 버린다.

## 유저 프로퍼티

이벤트가 아니라 **사람**에 붙는 값이다. `link_save`의 `link_source`는 그 저장 한 번에 붙지만,
`saved_link_count`는 그 사람에게 붙어 이후 모든 이벤트를 따라다닌다. 그래야
"링크 20개 이상 모은 유저의 검색 사용률" 같은 그룹핑이 된다.

| 프로퍼티 | 값 | 세팅 지점 | 상태 |
|---|---|---|---|
| `has_onboarded` | `true`/`false` | `AppFeature.onboardingStateLoaded`, 온보딩 완료 | ✅ |
| `saved_link_count` | 구간 (`0`,`1-4`,`5-19`,`20-49`,`50+`) | `AddLinkFeature.saveLinkResponse` | ✅ |
| `category_count` | 구간 | `AddCategoryFeature` | ✅ |
| `has_highlighted` | `true`/`false` | 확장 이벤트 큐에 `highlight_created`가 있으면 앱이 세팅 | ✅ |
| `device_shell` | `phone`/`pad`/`mac` | `AppDelegate.didFinishLaunching` | ✅ |

GA4는 유저 프로퍼티를 계정당 25개까지만 받는다 — 함부로 늘리지 않는다.

## 값 규칙

- **자유 입력(검색어·링크 제목)은 보내지 않는다.** 개인정보이고, GA4는 파라미터 값이 100자를
  넘으면 잘라내서 "긴 검색어"와 "잘린 검색어"가 같은 값으로 뭉개진다. 길이 구간(`query_length`)만 남긴다.
- **개수도 원값 대신 구간.** 유저 프로퍼티는 카디널리티가 낮아야 그룹핑이 된다.
- **`Bool`은 GA4로 갈 때 `"true"`/`"false"` 문자열**로 나간다 — 0/1보다 리포트에서 읽기 쉽다.
  Amplitude는 JSON이라 그대로 boolean.

## 키 설정

키가 없어도 앱은 그대로 돈다 — 프로바이더가 조용히 빠지고, Debug 빌드에선 콘솔 프로바이더가
무엇이 찍히는지 대신 보여준다.

```
xcrun simctl spawn booted log stream --level debug \
  --predicate 'subsystem == "TapTap" OR subsystem == "Amplitude"'
# [TapTap:AnalyticsKit] 분석 프로바이더 시작: Console, Amplitude
# [TapTap:AnalyticsKit] 📊 screen_view { screen_name=home }
# [Amplitude:Logging] Log: Start flushing 4 events
# [Amplitude:Logging] Debug: Successfully completed request   ← 서버가 받았다
```

Amplitude는 Debug 빌드에서 `logLevel: .debug`로 올려놨다. 기본값 `.warn`으로는 **성공한 전송이
아무 로그도 안 남겨서** 붙었는지 확인할 방법이 없다. 업로드는 30초 주기(또는 30건)라
`Start flushing`이 뜰 때까지 기다려야 한다.

- **GA4**: ⬜ 미완. Firebase 콘솔에서 iOS 앱(`com.Nbs.dev.ADA.app`) 등록 → `GoogleService-Info.plist`를
  `TapTap/Projects/App/Resources/`에 넣는다. 파일은 `.gitignore`에 걸려 있어 커밋되지 않는다.
- **Amplitude**: ✅ 완료 (2026-09-05, 데이터 리전 US). `TapTap/Tuist/Config/Project.xcconfig`(gitignore됨)에 한 줄.

  ```
  AMPLITUDE_API_KEY = <키>
  ```

  App 타깃 Info.plist가 `$(AMPLITUDE_API_KEY)`로 받아 `AnalyticsKit`이 읽는다.

## 아직 안 한 것

- **어트리뷰션 툴**(AppsFlyer / Airbridge). 웹은 UTM으로 광고→유입이 이어지지만 앱은 앱스토어를
  거치며 연결이 끊긴다. 이걸 못 이으면 "설치는 많지만 돈 안 쓰는 유저를 계속 데려오는" 잘못된
  의사결정을 하게 된다. 유료 광고를 집행하기 **전에** 붙여야 한다.
- **macOS(TapTapMac)**. `AnalyticsKit`은 iOS(iPhone·iPad) 타깃으로만 만들어져 있다. 맥에 붙이려면
  모듈 `destinations`에 `.mac`을 넣고 macOS용 `GoogleService-Info.plist`를 따로 받아야 한다.
- **수집 동의 UI**. `AnalyticsClient.setCollectionEnabled(_:)`는 준비돼 있지만 부르는 곳이 없다.
