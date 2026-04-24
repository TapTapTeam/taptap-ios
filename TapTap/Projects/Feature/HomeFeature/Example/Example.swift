//
//  Example.swift
//  HomeFeature
//
// Created by 홍 on 4/23/26.
//

import SwiftUI

import HomeFeature

import ComposableArchitecture

@main
struct Example: App {
  var body: some Scene {
    WindowGroup {
      HomeView(
        store: Store(initialState: HomeFeature.State()) {
          HomeFeature()
        }
      )
    }
  }
}
