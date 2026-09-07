//
//  UsageEvent.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

public enum UsageEvent: AnalyticsEventConvertible, Equatable, Sendable {
  case screenViewed(Screen)

  case onboardingStepViewed(step: Int, name: String)

  case onboardingSkipped(step: Int)

  case categoryFavoriteToggled(isFavorite: Bool)

  case linkFilterChanged(filter: String)

  case recentSearchTapped

  case safariGuideViewed

  case settingRowTapped(row: String)

  case categoryEdited(field: String)
  case categoryChipSelected
  case linkEditSheetOpened
  case relatedSearchTapped
  case recentLinkTapped
  case recentSearchDeleted(isAll: Bool)
  case summaryViewed
  case originalEditOpened
  case originalEditCompleted
  case categoryMenuTapped(action: String)

  public enum Screen: String, Equatable, Sendable {
    case onboarding
    case home
    case linkList = "link_list"
    case linkDetail = "link_detail"
    case addLink = "add_link"
    case search
    case myCategory = "my_category"
    case original
    case originalEdit = "original_edit"
    case setting
    case settingExtension = "setting_extension"
    case settingShare = "setting_share"
    case settingFavorite = "setting_favorite"
    case settingOpenSource = "setting_open_source"
    case settingPolicy = "setting_policy"
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

    case .categoryEdited(let field):
      return AnalyticsEvent(
        name: "category_edit",
        parameters: ["field": .string(field)]
      )

    case .categoryChipSelected:
      return AnalyticsEvent(name: "category_chip_select")

    case .linkEditSheetOpened:
      return AnalyticsEvent(name: "link_edit_sheet_open")

    case .relatedSearchTapped:
      return AnalyticsEvent(name: "related_search_tap")

    case .recentLinkTapped:
      return AnalyticsEvent(name: "recent_link_tap")

    case .recentSearchDeleted(let isAll):
      return AnalyticsEvent(
        name: "recent_search_delete",
        parameters: ["is_all": .bool(isAll)]
      )

    case .summaryViewed:
      return AnalyticsEvent(name: "summary_view")

    case .originalEditOpened:
      return AnalyticsEvent(name: "original_edit_open")

    case .originalEditCompleted:
      return AnalyticsEvent(name: "original_edit_complete")

    case .categoryMenuTapped(let action):
      return AnalyticsEvent(
        name: "category_menu_tap",
        parameters: ["action": .string(action)]
      )
    }
  }
}
