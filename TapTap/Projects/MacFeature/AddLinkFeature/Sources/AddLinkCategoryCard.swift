//
//  AddLinkCategoryCard.swift
//  MacAddLinkFeature
//
//  Created by 홍 on 05/31/26.
//

import SwiftUI

import DesignSystem

struct AddLinkCategoryCard: View {
  let title: String
  let countText: String?
  let iconNumber: Int?
  let isSelected: Bool
  let action: () -> Void
  
  @State private var isHovered: Bool = false
  
  var body: some View {
    Button(action: action) {
      ZStack(alignment: .bottomTrailing) {
        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(Color.text1)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text(countText ?? "0개")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(isSelected ? Color.caption1 : Color.caption2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
        DesignSystemAsset.primaryCategoryIcon(number: iconNumber ?? 1)
          .resizable()
          .scaledToFit()
          .frame(width: 56, height: 56)
          .offset(x: 2, y: 2)
      }
      .padding(16)
      .frame(height: 116)
      .frame(minWidth: 140, maxWidth: .infinity)
      .background(isSelected || isHovered ? Color.bl1 : Color.n0)
      .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
      .overlay {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .strokeBorder(isSelected ? Color.bl6 : .clear, lineWidth: 1.5)
      }
      .shadow(color: Color.bgShadow3, radius: 8, x: 0, y: 0)
    }
    .buttonStyle(.plain)
    .onHover { isHovered = $0 }
  }
}
