//
//  OriginalNavigation.Path.swift
//  OriginalFeature
//
//  Created by 여성일 on 2/22/26.
//

import ComposableArchitecture

extension OriginalArticleFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case originalEdit(OriginalEditFeature)
  }
}
