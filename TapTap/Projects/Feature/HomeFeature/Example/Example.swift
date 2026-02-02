//
//  Example.swift
//  HomeFeature
//
//  Created by 여성일 on 1/25/26.
//

import SwiftUI

import ComposableArchitecture
import LinkNavigator

import HomeFeature
import Shared

@main
struct Example: App {
//  let store = Store(initialState: HomeFeature.State()) {
//    HomeFeature()
//  }
//  
//  let singleNavigator = SingleLinkNavigator(
//    routeBuilderItemList: AppRouterGroup().routers(),
//    dependency: AppDependency()
//  )
  
  var body: some Scene {
    WindowGroup {
      //HomeView(navigator: singleNavigator, store: store)
    }
  }
}
