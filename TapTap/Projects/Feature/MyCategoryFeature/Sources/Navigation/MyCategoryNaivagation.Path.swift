//
//  MyCategoryNaivation.Path.swift
//  MyCategoryFeature
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

extension MyCategoryCollectionFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case editCategory(EditCategoryFeature)
    case editCategoryIconName(EditCategoryIconNameFeature)
    case addCategory(AddCategoryFeature)
    case deleteCategory(DeleteCategoryFeature)
  }
}
