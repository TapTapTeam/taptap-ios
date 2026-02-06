//
//  AppRouterGroup.swift
//  Nbs
//
//  Created by 홍 on 10/26/25.
//

import LinkNavigator

import HomeFeature
import MyCategoryFeature
import AddLinkFeature
import SearchFeature
import SettingFeature
import LinkListFeature
import LinkDetailFeature
import OriginalFeature

public struct AppRouterGroup {
  public init() { }
}

extension AppRouterGroup {

  @MainActor
  func routers() -> [RouteBuilderOf<SingleLinkNavigator>] {
    [
      //MARK: 앱
      HomeRouteBuilder().generate(),
      AddLinkRouteBuilder().generate(),
      MyCategoryRouteBuilder().generate(),
      AddCategoryRouteBuilder().generate(),
      EditCategoryRouteBuilder().generate(),
      DeleteCategoryRouteBuilder().generate(),
      CategorySettingRouteBuilder().generate(),
      SearchRouteBuilder().generate(),
      EditCategoryIconNameRouteBuilder().generate(),
      LinkListRouteBuilder().generate(),
      LinkDetailRouteBuilder().generate(),
      OriginalArticleRouteBuilder().generate(),
      OriginalEditRouteBuilder().generate(),
      MoveLinkRouteBuilder().generate(),
      DeleteLinkRouteBuilder().generate(),
      
      // MARK: - 설정
      SettingRouteBuilder().generate(),
      PolicyDetailRouteBuilder().generate(),
      OpenSourceListRouteBuilder().generate(),
      FavoriteSettingRouteBuilder().generate(),
      ExtensionSettingRouteBuilder().generate(),
      ShareSettingRouteBuilder().generate()
    ]
  }
}
