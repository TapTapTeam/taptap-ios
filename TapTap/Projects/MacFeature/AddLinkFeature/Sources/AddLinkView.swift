//
//  Sources.swift
//  AddLinkFeature
//
//  Created by TapTap on now.
//

import SwiftUI
import SwiftData

import Core
import DesignSystem

public struct AddLinkView: View {
  private let categories: [CategoryItem]
  private let totalLinkCount: Int
  private let onSave: (ArticleItem) -> Void
  
  @Environment(\.modelContext) private var modelContext
  
  @State private var linkURL: String = ""
  @State private var selectedCategoryID: UUID?
  @State private var isSaving: Bool = false
  @State private var statusMessage: String?
  @State private var isStatusError: Bool = false
  
  public init(
    categories: [CategoryItem] = [],
    totalLinkCount: Int = 0,
    onSave: @escaping (ArticleItem) -> Void = { _ in }
  ) {
    self.categories = categories
    self.totalLinkCount = totalLinkCount
    self.onSave = onSave
  }
  
  public var body: some View {
    VStack(spacing: 20) {
      topBar
      
      VStack(spacing: 24) {
        linkAddressSection
        categorySection
      }
      .frame(width: 600)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.background)
  }
}

private extension AddLinkView {
  var topBar: some View {
    ZStack {
      Text("링크 추가하기")
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(Color.text1)
      
      HStack {
        Spacer()
        
        Button {
          Task {
            await saveLink()
          }
        } label: {
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
          .foregroundStyle(canSubmit ? Color.bl6 : Color.caption2)
          .padding(.horizontal, 14)
          .padding(.vertical, 9)
          .background(canSubmit ? Color.bl1 : Color.n40)
          .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(!canSubmit)
      }
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
  
  var linkAddressSection: some View {
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
          statusMessage = nil
        }
      
      if let statusMessage {
        Text(statusMessage)
          .font(.system(size: 12, weight: .medium))
          .foregroundStyle(isStatusError ? Color.danger : Color.caption1)
          .padding(.horizontal, 4)
      }
    }
    .frame(alignment: .top)
  }
  
  var categorySection: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Text("카테고리 선택")
          .font(.system(size: 12, weight: .semibold))
          .foregroundStyle(Color.caption1)
        
        Spacer()
        
        Button {
        } label: {
          HStack(spacing: 4) {
            Image(icon: Icon.plus)
              .renderingMode(.template)
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
      
      ScrollView {
        LazyVGrid(columns: categoryColumns, alignment: .leading, spacing: 10) {
          CategoryCard(
            title: "전체",
            countText: "\(totalLinkCount)개",
            iconNumber: nil,
            isSelected: selectedCategoryID == nil
          ) {
            selectedCategoryID = nil
          }
          
          ForEach(categories) { category in
            CategoryCard(
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
  
  var categoryColumns: [GridItem] {
    Array(repeating: GridItem(.flexible(minimum: 140), spacing: 10), count: 4)
  }
  
  var isAddButtonEnabled: Bool {
    !linkURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
  
  var canSubmit: Bool {
    isAddButtonEnabled && !isSaving
  }
  
  func categoryCountText(_ category: CategoryItem) -> String? {
    guard let count = category.links?.count else { return nil }
    return "\(count)개"
  }
  
  func selectedCategory() -> CategoryItem? {
    guard let selectedCategoryID else { return nil }
    return categories.first { $0.id == selectedCategoryID }
  }
  
  @MainActor
  func saveLink() async {
    let normalizedURLString = normalizedURLString(from: linkURL)
    
    guard let url = URL(string: normalizedURLString), url.scheme != nil, url.host != nil else {
      showStatus("올바른 링크를 입력해주세요", isError: true)
      return
    }
    
    isSaving = true
    defer { isSaving = false }
    
    do {
      if try LinkService.shared.urlExists(normalizedURLString) {
        showStatus("이미 저장된 링크입니다", isError: true)
        return
      }
      
      let metadata = try await LinkService.shared.extractMetadata(from: url)
      let article = ArticleItem(
        urlString: normalizedURLString,
        title: metadata.title,
        imageURL: metadata.imageURL?.absoluteString
      )
      article.category = selectedCategory()
      
      modelContext.insert(article)
      try modelContext.save()
      
      linkURL = ""
      selectedCategoryID = nil
      showStatus("링크를 추가했어요", isError: false)
      onSave(article)
    } catch {
      showStatus("링크 추가에 실패했어요", isError: true)
    }
  }
  
  func normalizedURLString(from rawValue: String) -> String {
    let trimmedValue = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedValue.isEmpty else { return trimmedValue }
    
    if trimmedValue.contains("://") {
      return trimmedValue
    }
    
    return "https://\(trimmedValue)"
  }
  
  func showStatus(_ message: String, isError: Bool) {
    statusMessage = message
    isStatusError = isError
  }
}

private struct CategoryCard: View {
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
        
        categoryIcon
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
  
  @ViewBuilder
  private var categoryIcon: some View {
    if let iconNumber {
      DesignSystemAsset.primaryCategoryIcon(number: iconNumber)
        .resizable()
        .scaledToFit()
    } else {
      DesignSystemAsset.primaryCategoryIcon(number: 1)
        .resizable()
        .scaledToFit()
    }
  }
}
