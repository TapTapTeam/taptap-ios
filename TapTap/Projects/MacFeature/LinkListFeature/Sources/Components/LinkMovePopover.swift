//
//  LinkMovePopover.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import SwiftUI

import Core
import DesignSystem

/// 링크 이동하기를 눌렀을 때 나오는 팝오버입니다.
public struct LinkMovePopover: View {
  @Environment(\.dismiss) private var dismiss
  
  private let categories: [CategoryItem]
  private let selectedCategoryID: UUID?
  private let onSelect: (CategoryItem?) -> Void

  @State private var selectedCategory: CategoryItem?
  
  public init(
    categories: [CategoryItem],
    selectedCategoryID: UUID?,
    onSelect: @escaping (CategoryItem?) -> Void
  ) {
    self.categories = categories
    self.selectedCategoryID = selectedCategoryID
    self.onSelect = onSelect
    self._selectedCategory = State(
      initialValue: categories.first { $0.id == selectedCategoryID }
    )
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      header
      
      categoryList

      footer
    }
    .frame(width: 536, height: 400)
    .background(Color.background)
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}

private extension LinkMovePopover {
  var header: some View {
    HStack(spacing: 0) {
      Text("카테고리 이동하기")
        .font(.B1_SB)
        .foregroundStyle(.text1)
      
      Spacer(minLength: 0)
      
      Button {
        dismiss()
      } label: {
        DesignSystemAsset.x.swiftUIImage
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(.iconGray)
          .frame(width: 20, height: 20)
      }
      .buttonStyle(.plain)
      .frame(width: 40, height: 40)
      .contentShape(Rectangle())
    }
    .padding(.leading, 22)
    .padding(.trailing, 12)
    .padding(.top, 16)
    .padding(.bottom, 10)
  }
  
  var categoryList: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 0) {
        categoryRow(
          title: "전체",
          icon: Image(icon: Icon.linkMac),
          isSelected: selectedCategory == nil
        ) {
          selectedCategory = nil
        }
        
        ForEach(categories) { category in
          categoryRow(
            title: category.categoryName,
            icon: DesignSystemAsset.categoryIcon(number: category.icon.number),
            isSelected: selectedCategory?.id == category.id
          ) {
            selectedCategory = category
          }
        }
      }
    }
    .frame(maxHeight: .infinity)
    .overlay(alignment: .top) {
      verticalGradientFade(startPoint: .top, endPoint: .bottom)
    }
    .overlay(alignment: .bottom) {
      verticalGradientFade(startPoint: .bottom, endPoint: .top)
    }
  }

  var footer: some View {
    HStack {
      Spacer(minLength: 0)

      Button {
        onSelect(selectedCategory)
        dismiss()
      } label: {
        Text("확인")
          .font(.B1_SB)
          .foregroundStyle(.textw)
          .frame(width: 68, height: 46)
          .background(Color.bl6)
          .clipShape(RoundedRectangle(cornerRadius: 12))
      }
      .buttonStyle(.plain)
    }
    .padding(.horizontal, 20)
    .padding(.top, 12)
    .padding(.bottom, 18)
  }
  
  func categoryRow(
    title: String,
    icon: Image,
    isSelected: Bool,
    action: @escaping () -> Void
  ) -> some View {
    LinkMoveCategoryRow(
      title: title,
      icon: icon,
      isSelected: isSelected,
      action: action
    )
  }

  func verticalGradientFade(
    startPoint: UnitPoint,
    endPoint: UnitPoint
  ) -> some View {
    Rectangle()
      .fill(
        LinearGradient(
          stops: [
            Gradient.Stop(color: .bgButtonGrad1, location: 0.00),
            Gradient.Stop(color: .bgButtonGrad2, location: 0.16),
            Gradient.Stop(color: .bgButtonGrad3, location: 0.73),
            Gradient.Stop(color: .bgButtonGrad4, location: 1.00)
          ],
          startPoint: startPoint,
          endPoint: endPoint
        )
      )
      .frame(height: 28)
      .allowsHitTesting(false)
  }
}

private struct LinkMoveCategoryRow: View {
  let title: String
  let icon: Image
  let isSelected: Bool
  let action: () -> Void

  @State private var isHovered = false

  var body: some View {
    Button(action: action) {
      HStack(spacing: 10) {
        icon
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 28, height: 28)
        
        Text(title)
          .font(isSelected ? .B1_SB : .B1_M)
          .foregroundStyle(.text1)
          .lineLimit(1)
        
        Spacer(minLength: 0)
        
        if isSelected {
          Image(icon: Icon.check)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.bl6)
            .frame(width: 20, height: 20)
        }
      }
      .padding(.horizontal, 22)
      .frame(height: 44)
      .frame(maxWidth: .infinity)
      .background(backgroundColor)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .onHover { isHovered = $0 }
  }

  private var backgroundColor: Color {
    if isSelected {
      return .bl1
    }
    if isHovered {
      return .bgDimHover
    }
    return .clear
  }
}
