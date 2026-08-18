//
//  AddLinkMainContentView.swift
//  MacAddLinkFeature
//
//  Created by 홍 on 05/31/26.
//

import SwiftUI

import Core
import DesignSystem

struct AddLinkMainContentView: View {
  let categories: [CategoryItem]
  let totalLinkCount: Int
  let isSaving: Bool
  let canSubmit: Bool
  let onAdd: () -> Void
  let onAddCategory: () -> Void
  let onLinkURLChanged: () -> Void
  let onBack: () -> Void

  @Binding var linkURL: String
  @Binding var selectedCategoryID: UUID?

  var body: some View {
    VStack(spacing: 20) {
      AddLinkTopBar(
        isSaving: isSaving,
        canSubmit: canSubmit,
        onAdd: onAdd,
        onBack: onBack
      )
      
      VStack(spacing: 24) {
        AddLinkAddressSection(
          linkURL: $linkURL,
          onLinkURLChanged: onLinkURLChanged
        )
        
        AddLinkCategorySection(
          categories: categories,
          totalLinkCount: totalLinkCount,
          onAddCategory: onAddCategory,
          selectedCategoryID: $selectedCategoryID
        )
      }
      .frame(width: 600)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
  }
}

private struct AddLinkTopBar: View {
  let isSaving: Bool
  let canSubmit: Bool
  let onAdd: () -> Void
  let onBack: () -> Void

  var body: some View {
    ZStack {
      Text("링크 추가하기")
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(Color.text1)

      HStack {
        MacBackForwardButton(
          isBackEnabled: true,
          isForwardEnabled: false,
          onBackTap: onBack,
          onForwardTap: {}
        )

        Spacer()

        Button(action: onAdd) {
          AddLinkSubmitButtonLabel(isSaving: isSaving)
            .foregroundStyle(canSubmit ? Color.bl6 : Color.caption2)
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(canSubmit ? Color.bl1 : Color.n40)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(!canSubmit)
      }
      .padding(.leading, 20)
      .padding(.trailing, 32)
    }
    .padding(.bottom, 20)
    .frame(maxWidth: .infinity)
    .background(Color.n0)
    .overlay(alignment: .bottom) {
      Rectangle()
        .fill(Color.divider1)
        .frame(height: 1)
    }
  }
}

private struct AddLinkSubmitButtonLabel: View {
  let isSaving: Bool
  
  var body: some View {
    HStack(spacing: 6) {
      if isSaving {
        ProgressView()
          .controlSize(.small)
          .frame(width: 15, height: 15)
      } else {
        Image(systemName: "plus")
          .font(.system(size: 15, weight: .semibold))
      }
      
      Text(isSaving ? "추가 중" : "추가")
        .font(.system(size: 16, weight: .semibold))
    }
  }
}

private struct AddLinkAddressSection: View {
  @Binding var linkURL: String
  
  let onLinkURLChanged: () -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("추가할 링크")
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(Color.caption1)
        .padding(.horizontal, 4)
      
      TextField("링크를 입력해주세요", text: $linkURL)
        .textFieldStyle(.plain)
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(Color.text1)
        .padding(16)
        .frame(height: 56)
        .background(Color.n0)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .strokeBorder(Color.divider1, lineWidth: 1)
        }
        .onChange(of: linkURL) { _, _ in
          onLinkURLChanged()
        }
    }
    .frame(alignment: .top)
  }
}

private struct AddLinkCategorySection: View {
  let categories: [CategoryItem]
  let totalLinkCount: Int
  let onAddCategory: () -> Void
  
  @Binding var selectedCategoryID: UUID?
  
  private var categoryColumns: [GridItem] {
    Array(repeating: GridItem(.flexible(minimum: 140), spacing: 10), count: 4)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      AddLinkCategoryHeader(onAddCategory: onAddCategory)
      
      ScrollView {
        LazyVGrid(columns: categoryColumns, alignment: .leading, spacing: 10) {
          AddLinkCategoryCard(
            title: "전체",
            countText: "\(totalLinkCount)개",
            iconNumber: 24,
            isSelected: selectedCategoryID == nil
          ) {
            selectedCategoryID = nil
          }
          
          ForEach(categories) { category in
            AddLinkCategoryCard(
              title: category.categoryName,
              countText: categoryCountText(category),
              iconNumber: category.icon.number,
              isSelected: selectedCategoryID == category.id
            ) {
              selectedCategoryID = category.id
            }
          }
        }
        .padding(.top, 8)
        .padding(.bottom, 40)
      }
      .scrollIndicators(.hidden)
      .overlay(alignment: .top) {
        LinearGradient(
          colors: [Color.background, Color.background.opacity(0)],
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: 12)
        .allowsHitTesting(false)
      }
      .overlay(alignment: .bottom) {
        LinearGradient(
          colors: [Color.background.opacity(0), Color.background],
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: 35)
        .allowsHitTesting(false)
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
  }
  
  private func categoryCountText(_ category: CategoryItem) -> String? {
    guard let count = category.links?.count else { return nil }
    return "\(count)개"
  }
}

private struct AddLinkCategoryHeader: View {
  let onAddCategory: () -> Void
  
  var body: some View {
    HStack {
      Text("카테고리 선택")
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(Color.caption1)
      
      Spacer()
      
      Button(action: onAddCategory) {
        HStack(spacing: 4) {
          Image(icon: Icon.plus)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundStyle(.bl6)

          Text("새 카테고리")
            .font(.system(size: 12, weight: .semibold))
        }
        .foregroundStyle(Color.bl6)
        .padding(.leading, 10)
        .padding(.trailing, 16)
        .frame(height: 34)
        .background(Color.bl1)
        .clipShape(Capsule())
      }
      .buttonStyle(.plain)
    }
    .padding(.leading, 4)
  }
}
