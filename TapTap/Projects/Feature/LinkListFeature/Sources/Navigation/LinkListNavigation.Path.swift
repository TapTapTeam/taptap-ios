//
//  LinkListNavigation.Path.swift
//  LinkListFeature
//
//  Created by 여성일 on 2/22/26.
//

import ComposableArchitecture

extension LinkListFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case moveLink(MoveLinkFeature)
    case deleteLink(DeleteLinkFeature)
  }
}
