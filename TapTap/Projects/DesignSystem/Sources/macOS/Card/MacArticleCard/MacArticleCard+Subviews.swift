//
//  MacArticleCard+Subviews.swift
//  DesignSystem
//
//  Created by 이승진 on 4/13/26.
//

#if os(macOS)

import SwiftUI

extension MacArticleCard {
  var textContents: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(title)
        .font(.B1_M)
        .foregroundStyle(.text1)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
        .padding(.leading, 14)
        .padding(.top, 10)

      Text(dateString)
        .font(.B2_M)
        .foregroundStyle(.caption2)
        .padding(.leading, 14)
        .padding(.top, 2)

      Spacer()

      Text(categoryName ?? "전체")
        .font(.B2_M)
        .foregroundStyle(.caption1)
        .padding(.vertical, 2)
        .padding(.horizontal, 10)
        .background(.n20)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(.leading, 12)
        .padding(.bottom, 10)
    }
  }

  var rightContents: some View {
    ZStack(alignment: .bottomTrailing) {
      articleImage
        .padding(.vertical, 10)
        .padding(.trailing, 10)

      if visualState == .defaultHover {
        editButton
          .padding(.trailing, 18)
          .padding(.bottom, 18)
          .transition(.opacity.combined(with: .scale(scale: 0.95)))
      }
    }
  }

  var articleImage: some View {
    AsyncImage(url: URL(string: imageURL ?? "")) { phase in
      switch phase {
      case .empty:
        ProgressView()
          .frame(width: 90, height: 90)

      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 90, height: 90)
          .clipped()
          .clipShape(RoundedRectangle(cornerRadius: 8))

      case .failure:
        DesignSystemAsset.notImage.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 90, height: 90)
          .foregroundStyle(.gray)
          .clipped()
          .clipShape(RoundedRectangle(cornerRadius: 8))

      @unknown default:
        EmptyView()
      }
    }
    .overlay {
      if shouldDimImage {
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.bgDim)
      }
    }
  }

  var editButton: some View {
    Button {
      showEditMenu = true
    } label: {
      DesignSystemAsset.edit2.swiftUIImage
        .resizable()
        .renderingMode(.template)
        .foregroundStyle(isEditButtonHovered ? Color.icon : Color.iconGray)
        .frame(width: 24, height: 24)
        .frame(width: 36, height: 36)
        .background(isEditButtonHovered ? Color.n0 : Color.n10)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onHover { isEditButtonHovered = $0 }
    }
    .buttonStyle(.plain)
    .popover(isPresented: $showEditMenu, arrowEdge: .leading) {
      editMenu
    }
  }

  var editMenu: some View {
    VStack(alignment: .leading, spacing: 0) {
      Button {
        showEditMenu = false
        onMoveTap?()
      } label: {
        Label("링크 이동하기", systemImage: "arrow.up.right.square")
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .foregroundStyle(.primary)
      }
      .buttonStyle(.plain)

      Divider()

      Button {
        showEditMenu = false
        onDeleteTap?()
      } label: {
        Label("링크 삭제하기", systemImage: "trash")
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .foregroundStyle(.red)
      }
      .buttonStyle(.plain)
    }
    .frame(width: 180)
  }

  var selectionIndicator: some View {
    Button {
      isSelected.toggle()
    } label: {
      ZStack {
        Circle()
          .stroke(
            isSelected ? Color.bl6 : Color.n90,
            lineWidth: 1.5
          )
          .frame(width: 20, height: 20)

        if isSelected {
          Circle()
            .fill(Color.bl6)
            .frame(width: 20, height: 20)

          DesignSystemAsset.check.swiftUIImage
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 14)
            .foregroundStyle(.iconW)
        }
      }
    }
    .buttonStyle(.plain)
  }
}

#endif
