//
//  SearchDropdownPanel.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import DesignSystem

public struct SearchDropdownPanel: View {
  @ObservedObject private var viewModel: SearchViewModel
  @FocusState private var isFocused: Bool
  private let onClose: () -> Void
  
  public init(
    viewModel: SearchViewModel,
    onClose: @escaping () -> Void
  ) {
    self.viewModel = viewModel
    self.onClose = onClose
  }
}

public extension SearchDropdownPanel {
  var body: some View {
    VStack(spacing: 0) {
      SearchBar(
        text: Binding(
          get: { viewModel.query },
          set: { viewModel.updateQuery($0) }
        ),
        isFocused: $isFocused,
        onSubmit: {
          viewModel.submitQuery()
          onClose()
        }
      )
      .padding(.top, 20)
      
      content
    }
    .frame(width: 640)
    .frame(minHeight: 300, alignment: .top)
    .background(.n0)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .onAppear {
      DispatchQueue.main.async {
        isFocused = true
      }
    }
  }

  @ViewBuilder
  private var content: some View {
    switch viewModel.state {
    case .empty:
      if viewModel.recentLinks.isEmpty {
        SearchQueryEmptyView()
          .frame(maxWidth: .infinity)
          .padding(.top, 30)
          .padding(.bottom, 20)
      } else {
        SearchRecentLinksView(
          items: viewModel.recentLinks,
          onTap: { _ in onClose() },
          onDelete: { viewModel.removeRecentLink($0) },
          onClear: { viewModel.clearRecentLinks() }
        )
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .padding(.bottom, 20)
      }

    case let .recent(items):
      VStack(alignment: .leading, spacing: 24) {
        SearchRecentView(
          recentQuery: .constant(items),
          onTap: { keyword in
            viewModel.selectRecentKeyword(keyword)
            onClose()
          },
          onDelete: { viewModel.removeRecent($0) },
          onClear: { viewModel.clearRecent() }
        )

        if !viewModel.recentLinks.isEmpty {
          SearchRecentLinksView(
            items: viewModel.recentLinks,
            onTap: { _ in onClose() },
            onDelete: { viewModel.removeRecentLink($0) },
            onClear: { viewModel.clearRecentLinks() }
          )
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 20)
      .padding(.top, 30)
      .padding(.bottom, 20)

    case let .related(keywords):
      SearchRelatedView(
        keywords: keywords,
        query: viewModel.query,
        onTap: { keyword in
          viewModel.selectRelatedKeyword(keyword)
          onClose()
        }
      )
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 20)
      .padding(.top, 30)
      .padding(.bottom, 20)
    }
  }

  private var recentLinksSection: some View {
    SearchRecentLinksView(
      items: viewModel.recentLinks,
      onTap: { item in
        onClose()
      },
      onDelete: { id in
        viewModel.removeRecentLink(id)
      },
      onClear: {
        viewModel.clearRecentLinks()
      }
    )
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 20)
    .padding(.top, 30)
    .padding(.bottom, 20)
  }
}
