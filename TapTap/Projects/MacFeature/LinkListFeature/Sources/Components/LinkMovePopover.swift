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
  
  public init(
    categories: [CategoryItem],
    selectedCategoryID: UUID?,
    onSelect: @escaping (CategoryItem?) -> Void
  ) {
    self.categories = categories
    self.selectedCategoryID = selectedCategoryID
    self.onSelect = onSelect
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      header
      
      categoryList
    }
    .frame(width: 560)
    .background(Color.n0)
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
    ScrollView {
      VStack(spacing: 4) {
        categoryRow(
          title: "전체",
          icon: Image(icon: Icon.linkMac),
          isSelected: selectedCategoryID == nil
        ) {
          selectCategory(nil)
        }
        
        ForEach(categories) { category in
          categoryRow(
            title: category.categoryName,
            icon: DesignSystemAsset.categoryIcon(number: category.icon.number),
            isSelected: selectedCategoryID == category.id
          ) {
            selectCategory(category)
          }
        }
      }
      .padding(.horizontal, 12)
      .padding(.bottom, 8)
    }
    .frame(maxHeight: 560)
  }
  
  func selectCategory(_ category: CategoryItem?) {
    onSelect(category)
    dismiss()
  }
  
  func categoryRow(
    title: String,
    icon: Image,
    isSelected: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      HStack(spacing: 10) {
        icon
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24, height: 24)
        
        Text(title)
          .font(.B1_M)
          .foregroundStyle(.text1)
          .lineLimit(1)
        
        Spacer(minLength: 0)
        
        if isSelected {
          Image(icon: Icon.check)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.bl6)
            .frame(width: 16, height: 16)
        }
      }
      .padding(.horizontal, 12)
      .frame(height: 36)
      .background(isSelected ? Color.bl1 : Color.clear)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .contentShape(RoundedRectangle(cornerRadius: 8))
    }
    .buttonStyle(.plain)
  }
}
