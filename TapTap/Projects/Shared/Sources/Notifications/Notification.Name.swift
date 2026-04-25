//
//  Notification.Name.swift
//  Shared
//
//  Created by 여성일 on 2/3/26.
//

import Foundation

extension Notification.Name {
  public static let categoryAdded = Notification.Name("categoryAdded")
  public static let categoryDeleted = Notification.Name("categoryDeleted")
  public static let categoryEdited = Notification.Name("categoryEdited")
  public static let linkSaved = Notification.Name("linkSaved")
  public static let linkDeleted = Notification.Name("linkDeleted")
  public static let linkMoved = Notification.Name("linkMoved")
  public static let firstlinkSaved = Notification.Name("firstlinkSaved")
  public static let editCompleted = Notification.Name("editCompleted")
}
