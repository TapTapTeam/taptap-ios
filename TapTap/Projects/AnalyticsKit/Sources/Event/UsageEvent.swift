//
//  UsageEvent.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

/// **UI 종속 이벤트** — 지금의 화면 구성이 잘 굴러가는지 보는 사용성 지표.
///
/// 화면이 사라지면 이 이벤트도 같이 사라져도 된다. 그래서 ``ConversionEvent``와 섞지 않는다.
/// 섞어두면 UI를 바꿀 때마다 전환 지표가 같이 끊겨서, "개선했더니 수치가 떨어졌다"인지
/// "이벤트가 안 찍히는 것"인지 구분이 안 된다.
public enum UsageEvent: AnalyticsEventConvertible, Equatable, Sendable {
  /// 화면 진입.
  case screenViewed(Screen)

  /// 온보딩 단계별 노출 — 어디서 이탈하는지 보려는 것이고, 온보딩 UI가 바뀌면 정의도 바뀐다.
  case onboardingStepViewed(step: Int, name: String)

  /// 온보딩을 건너뛰었다.
  case onboardingSkipped(step: Int)

  /// 카테고리 즐겨찾기 토글.
  case categoryFavoriteToggled(isFavorite: Bool)

  /// 링크 목록 필터 변경.
  case linkFilterChanged(filter: String)

  /// 최근 검색어를 눌러 검색했다 (직접 입력과 구분).
  case recentSearchTapped

  /// 사파리 확장 안내 시트를 봤다.
  case safariGuideViewed

  /// 설정에서 항목을 눌렀다.
  case settingRowTapped(row: String)

  /// 화면 이름은 문자열 리터럴 대신 여기 모아둔다 — 오타 하나면 리포트에서 화면이 둘로 갈린다.
  public enum Screen: String, Equatable, Sendable {
    case onboarding
    case home
    case linkList = "link_list"
    case linkDetail = "link_detail"
    case addLink = "add_link"
    case search
    case myCategory = "my_category"
    case original
    case setting
  }

  public var event: AnalyticsEvent {
    switch self {
    case .screenViewed(let screen):
      return AnalyticsEvent(
        name: "screen_view",
        parameters: ["screen_name": .string(screen.rawValue)]
      )

    case .onboardingStepViewed(let step, let name):
      return AnalyticsEvent(
        name: "onboarding_step_view",
        parameters: [
          "step_index": .int(step),
          "step_name": .string(name)
        ]
      )

    case .onboardingSkipped(let step):
      return AnalyticsEvent(
        name: "onboarding_skip",
        parameters: ["step_index": .int(step)]
      )

    case .categoryFavoriteToggled(let isFavorite):
      return AnalyticsEvent(
        name: "category_favorite_toggle",
        parameters: ["is_favorite": .bool(isFavorite)]
      )

    case .linkFilterChanged(let filter):
      return AnalyticsEvent(
        name: "link_filter_change",
        parameters: ["filter": .string(filter)]
      )

    case .recentSearchTapped:
      return AnalyticsEvent(name: "recent_search_tap")

    case .safariGuideViewed:
      return AnalyticsEvent(name: "safari_guide_view")

    case .settingRowTapped(let row):
      return AnalyticsEvent(
        name: "setting_row_tap",
        parameters: ["row": .string(row)]
      )
    }
  }
}
