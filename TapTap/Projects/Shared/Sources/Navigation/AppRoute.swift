//
//  AppRoute.swift
//  Shared
//
//  Created by 여성일 on 2/21/26.
//

import Foundation

import Core

public enum AppRoute: Equatable {
  case setting
  case addLink(CopiedLink?)
  case addCategory
  case linkDetail
  case search
}
