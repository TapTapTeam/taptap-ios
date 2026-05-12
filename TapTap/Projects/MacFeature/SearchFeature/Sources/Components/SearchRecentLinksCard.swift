//
//  SearchRecentLinksCard.swift
//  MacSearchFeature
//
//  Created by 여성일 on 4/27/26.
//

import SwiftUI
import DesignSystem

public struct SearchRecentLinksCard: View {
  private let title: String
  private let onTap: () -> Void
  private let image: String?
  @State private var isHovered = false
  
  public init(
    title: String = "",
    image: String?,
    onTap: @escaping () -> Void,
  ) {
    self.title = title
    self.image = image
    self.onTap = onTap
  }
}

public extension SearchRecentLinksCard {
  var body: some View {
    ZStack(alignment: .trailing) {
      Button(action: onTap) {
        HStack(spacing: 10) {
          Text(title)
            .font(.B1_M)
            .lineLimit(2)
            .frame(width: 210, height: 42, alignment: .leading)
            .foregroundStyle(.text1)

          thumbnailView
            .overlay {
              if isHovered {
                Color.dim
                  .clipShape(RoundedRectangle(cornerRadius: 8))
              }
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 4)
        .padding(.vertical, 4)
        .overlay {
          if isHovered {
            Color.macDimHover
          }
        }
      }
      .frame(width: 296)
      .contentShape(Rectangle())
      .background(Color.background)
      .buttonStyle(.plain)
      .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .onHover { isHovered = $0 }
    .animation(.easeOut(duration: 0.1), value: isHovered)
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
    .frame(width: 62, height: 62)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

#Preview {
  SearchRecentLinksCard(
    title: "링크제목이 들어갈 자리입니다 링크제목링크제목이 들어갈 자리입니다 링크제목링크제목이 들어갈 자리입니다 링크제목",
    image: "notImage",
    onTap: {
      
    }
  )
}
