//
//  RootView.swift
//  TapTapMac
//
//  Created by 여성일 on 4/6/26.
//

import Core
import SwiftUI
import SwiftData
import MacSearchFeature

struct RootView: View {
  @Query private var articles: [ArticleItem]

  var body: some View {
    MACContentView(
      articles: articles,
      searchViewModel: SearchViewModel(
        searchService: DefaultSearchService { articles },
        recentService: DefaultRecentSearchService()
      )
    )
    .background(Color.background)
  }
}
