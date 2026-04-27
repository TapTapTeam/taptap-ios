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
  private let onDelete: () -> Void
  private let image: String?
  @State private var isHovered = false
  @State private var isDeleteHovered = false
  
  public init(
    title: String = "",
    image: String?,
    onTap: @escaping () -> Void,
    onDelete: @escaping () -> Void
  ) {
    self.title = title
    self.image = image
    self.onTap = onTap
    self.onDelete = onDelete
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

      if isHovered {
        deleteButton
          .padding(.trailing, 4)
          .padding(.bottom, 33.5)
      }
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
  
  private var deleteButton: some View {
    Button(action: onDelete) {
      Image(icon: "macX")
        .renderingMode(.template)
        .foregroundStyle(isDeleteHovered ? .icon : .iconGray)
        .frame(width: 24, height: 24)
    }
    .buttonStyle(.plain)
    .frame(width: 28, height: 28)
    .background(.n10)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8)
        .strokeBorder(Color.divider2, lineWidth: 0.5)
    }
    .onHover { isDeleteHovered = $0 }
    .animation(.easeOut(duration: 0.1), value: isDeleteHovered)
  }
}

#Preview {
  SearchRecentLinksCard(
    title: "링크제목이 들어갈 자리입니다 링크제목링크제목이 들어갈 자리입니다 링크제목링크제목이 들어갈 자리입니다 링크제목",
    image: "notImage",
    onTap: {
      
    },
    onDelete: {
      
    }
  )
}
