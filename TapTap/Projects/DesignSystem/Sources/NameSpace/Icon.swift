//
//  Icon.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI

public enum Icon {}

///Image(icon: Icon.search) 으로 사용하기
public extension Icon {
  static let chevronLeft = "chevron-left"
  static let chevronRight = "chevron-right"
  static let arrowUp = "arrow-up"
  static let plus = "plus"
  static let x = "x"
  static let search = "search"
  static let settings = "settings"
  static let moreVertical = "more-vertical"
  static let move = "move"
  static let moveThin = "moveThin"
  static let trash2 = "trash-2"
  static let trash = "trash"
  static let share = "share"
  static let edit = "edit"
  static let edit2 = "edit2"
  static let calendar = "calendar"
  static let book = "book"
  static let tag = "tag"
  static let check = "check"
  static let alertCircle = "alert-circle"
  static let helpCircle = "help-circle"
  static let info = "info"
  static let heart = "heart"
  static let smallxCircleFilled = "small-x-circle-filled"
  static let smallChevronRight = "small-chevron-right"
  static let smallChevronDown = "small-chevron-down"
  static let smallPlus = "small-plus"
  static let circlePlus = "circlePlus"
  static let badgeCheck = "badge-check"
  static let shield = "shield"
  static let smile = "smile"
  static let smallMove = "small-move"
  static let opensource = "opensource"
  static let file = "file"
  static let checkUnfill = "check-unfill"
  static let checkFill = "check-fill"
  static let bookmark = "bookmark"
  static let favorite = "favorite"
  static let arrowLeft = "arrow-left"
  static let arrowRight = "arrow-right"
  static let linkMac = "linkMac"
  static let link = "link"
  static let plusThin = "plusThin"
  static let macX = "macX"
  static let smallChevronUp = "small-chevron-up"
  static let history = "history"
  static let openWindow = "openWindow"
  static let sidebarClose = "sidebarClose"
  static let sidebarOpen = "sidebarOpen"
}

public enum MacIcon {}

public extension MacIcon {
  static let logo = "mac_logo"
  static let sidebarOpen = "mac_sidebar_open"
  static let sidebarClose = "mac_sidebar_close"
  static let sidebarEdit = "mac_sidebar_edit"
  static let plus = "mac_plus"
  static let plusCircle = "mac_plus_circle"
  static let close = "mac_close"
  static let more = "mac_more"
  static let linkActive = "mac_linkActive"
  static let linkInactive = "mac_linkInactive"
  static let openWindow = "mac_openWindow"
  static let trash = "mac_trash"
  static let bookmark = "mac_bookmark"
  static let edit = "mac_edit"
  static let setting = "mac_setting"
  static let squareEdit = "mac_square_edit"
  static let trashBold = "mac_trash_bold"
  static let link = "mac_link"
  static let file = "mac_file"
  static let heart = "mac_heart"
  static let info = "mac_info"
  static let opensource = "mac_opensource"
  static let shield = "mac_shield"
  static let chevron_right = "mac_chevron_right"
  static let chevron_left = "mac_chevron_left"
}

public extension Image {
  init(icon name: String) {
    self.init(name, bundle: .module)
  }
}
