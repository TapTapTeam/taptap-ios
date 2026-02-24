//
//  AppCoordinator.swift
//  TapTap
//
//  Created by 여성일 on 2/23/26.
//

import ComposableArchitecture

import AddLinkFeature
import HomeFeature
import SettingFeature
import OnboardingFeature
import OriginalFeature

@Reducer
public struct AppCoordinator {
  public struct State: Equatable {
    var path = StackState<Path.State>()
    var home = HomeFeature.State()
  }
  
  public enum Action: Equatable {
    case path(StackActionOf<Path>)
    case home(HomeFeature.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.home, action: \.home) { HomeFeature() }
    Reduce { state, action in
      switch action {
      case .home(.delegate(.route(.setting))):
        state.path.append(.setting(.init()))
        return .none
        
      case .home(.delegate(.route(.addLink(let copiedLink)))):
        state.path.append(.addLink(.init(linkURL: copiedLink?.url ?? "")))
        return .none
        
      case .home(.delegate(.route(.search))):
        state.path.append(.search(.init()))
        return .none
        
      case .home(.delegate(.route(.linkList(let categoryName)))):
        state.path.append(.linkList(.init(initialCategoryName: categoryName)))
        return .none
        
      case .home(.delegate(.route(.linkDetail(let article)))):
        state.path.append(.linkDetail(.init(article: article)))
        return .none
        
      case .home(.delegate(.route(.addCategory))):
        state.path.append(.addCategory(.init()))
        return .none
        
      case .home(.delegate(.route(.myCategoryCollection))):
        state.path.append(.myCategoryCollection(.init()))
        return .none
    
      case .home, .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    
    AddLinkCoordinatorReducer()
    MyCategoryCoordinator()
    SettingCoordinatorReducer()
    SearchCoordinator()
    LinkDetailCoordinator()
    LinkListCoordinator()
    OriginalCoordinator()
  }

  public init() {}
}
