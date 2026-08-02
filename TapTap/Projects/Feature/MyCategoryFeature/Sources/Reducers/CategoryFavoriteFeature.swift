//
//  CategoryFavoriteFeature.swift
//  Feature
//

import ComposableArchitecture

import Core

/// 카테고리 롱프레스 시 뜨는 즐겨찾기 추가/해제 바텀시트.
///
/// `CategorySettingFeature`와 동일하게, 액션은 부모(`MyCategoryCollectionFeature`)가
/// 처리하고 여기서는 상태(대상 카테고리 / 현재 즐겨찾기 여부)만 보관한다.
@Reducer
public struct CategoryFavoriteFeature {
  @ObservableState
  public struct State: Equatable {
    public var category: CategoryItem
    public var isFavorite: Bool

    public init(category: CategoryItem) {
      self.category = category
      self.isFavorite = category.isFavorite
    }
  }

  public enum Action: Equatable {
    case dismissButtonTapped
    case toggleButtonTapped
  }

  public var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case .dismissButtonTapped:
        return .none

      case .toggleButtonTapped:
        return .none
      }
    }
  }

  public init() {}
}
