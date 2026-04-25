//
//  SearchResultCard.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//
//
//  SearchResultCard.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/6/26.
//

import SwiftUI
import DesignSystem

public struct SearchResultCard: View {
  private let action: () -> Void
  private let title: String
  private let date: String
  private let category: String
  private let image: String?

  @State private var isHovered = false

  public init(
    title: String,
    date: String,
    category: String,
    image: String?,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.date = date
    self.category = category
    self.image = image
    self.action = action
  }
}

public extension SearchResultCard {
  var body: some View {
    Button(action: action) {
      HStack {
        VStack(alignment: .leading) {
          VStack(alignment: .leading, spacing: 2) {
            Text(title)
              .font(.B1_M)
              .foregroundStyle(.text1)
              .lineLimit(1)

            Text(date)
              .font(.B2_M)
              .foregroundStyle(.caption2)
          }

          Spacer()

          Text(category)
            .font(.B2_M)
            .foregroundStyle(.caption1)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.n20)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }

        Spacer()

        thumbnailView
      }
      .padding(.vertical, 10)
      .padding(.leading, 12)
      .padding(.trailing, 10)
      .frame(maxWidth: .infinity)
      .frame(height: 110)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .onHover { hovering in
      isHovered = hovering
    }
    .animation(.easeOut(duration: 0.12), value: isHovered)
  }

  private var thumbnailView: some View {
    Group {
      if let image, !image.isEmpty, let url = URL(string: image) {
        AsyncImage(url: url) { phase in
          switch phase {
          case .success(let loadedImage):
            loadedImage
              .resizable()
              .scaledToFill()

          case .empty, .failure:
            Image("notImage")
              .resizable()
              .scaledToFill()

          @unknown default:
            Image("notImage")
              .resizable()
              .scaledToFill()
          }
        }
      } else {
        Image("notImage")
          .resizable()
          .scaledToFill()
      }
    }
    .frame(width: 90, height: 90)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }

  private var backgroundColor: Color {
    isHovered ? .n40 : .n0
  }
}
