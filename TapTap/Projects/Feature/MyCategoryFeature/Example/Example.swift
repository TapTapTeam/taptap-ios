//
//  Example.swift
//  HomeFeature
//
//  Created by 여성일 on 1/25/26.
//

import SwiftUI

import ComposableArchitecture

import MyCategoryFeature

@main
struct Example: App {
  let store = Store(initialState: CategoryListFeature.State()) {
    CategoryListFeature()
  }
  var body: some Scene {
    WindowGroup {
      CategoryListView(store: store)
    }
  }
}
