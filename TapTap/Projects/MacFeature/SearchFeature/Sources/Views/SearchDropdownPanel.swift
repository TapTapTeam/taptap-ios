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

  private let maxAvailableHeight: CGFloat

  @State private var measuredContentHeight: CGFloat = 0
  @State private var panelHeight: CGFloat = 300

  private let minPanelHeight: CGFloat = 300
  private let headerHeight: CGFloat = 90

  public init(
    viewModel: SearchViewModel,
    maxAvailableHeight: CGFloat,
    onClose: @escaping () -> Void
  ) {
    self.viewModel = viewModel
    self.maxAvailableHeight = maxAvailableHeight
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
      .padding(.horizontal, 20)
      .padding(.top, 20)

      content
    }
    .frame(maxWidth: 640)
    .frame(height: panelHeight, alignment: .top)
    .background(.n0)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .onAppear {
      DispatchQueue.main.async {
        isFocused = true
      }
      updatePanelHeight()
    }
    .onChange(of: maxAvailableHeight) { _, _ in
      updatePanelHeight()
    }
  }

  private func updatePanelHeight() {
    let totalNeededHeight = measuredContentHeight + headerHeight
    let effectiveMaxHeight = max(0, maxAvailableHeight)
    let effectiveMinHeight = min(minPanelHeight, effectiveMaxHeight)
    panelHeight = min(max(totalNeededHeight, effectiveMinHeight), effectiveMaxHeight)
  }

  @ViewBuilder
  private var content: some View {
    scrollableContent
      .padding(.top, 30)
      .onPreferenceChange(ContentHeightPreferenceKey.self) { measuredHeight in
        measuredContentHeight = measuredHeight
        updatePanelHeight()
      }
  }

  @ViewBuilder
  private var scrollableContent: some View {
    switch viewModel.state {
    case .empty:
      if viewModel.recentLinks.isEmpty {
        SearchQueryEmptyView()
          .frame(maxWidth: .infinity)
          .padding(.bottom, 20)
          .background(GeometryPreferenceReader())
      } else {
        ScrollView {
          SearchRecentLinksView(
            items: viewModel.recentLinks,
            showDivider: false,
            onTap: { _ in onClose() }
          )
          .frame(maxWidth: .infinity)
          .padding(.bottom, 20)
          .background(GeometryPreferenceReader())
        }
      }

    case let .recent(items):
      ScrollView {
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
              onTap: { _ in onClose() }
            )
          }
        }
        .padding(.bottom, 20)
        .background(GeometryPreferenceReader())
      }
      .frame(maxWidth: .infinity, alignment: .leading)

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
      .padding(.bottom, 20)
      .background(GeometryPreferenceReader())
    }
  }

  private var recentLinksSection: some View {
    SearchRecentLinksView(
      items: viewModel.recentLinks,
      onTap: { item in
        onClose()
      }
    )
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 20)
    .padding(.top, 30)
    .padding(.bottom, 20)
  }
}

private struct ContentHeightPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}

private struct GeometryPreferenceReader: View {
  var body: some View {
    GeometryReader { geo in
      Color.clear
        .preference(key: ContentHeightPreferenceKey.self, value: geo.size.height)
    }
  }
}
