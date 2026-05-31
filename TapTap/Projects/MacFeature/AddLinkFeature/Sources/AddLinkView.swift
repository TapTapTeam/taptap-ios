//
//  Sources.swift
//  AddLinkFeature
//
//  Created by 홍 on 05/31/26.
//

import SwiftUI
import SwiftData

import Core
import DesignSystem

public struct AddLinkView: View {
  private let categories: [CategoryItem]
  private let totalLinkCount: Int
  private let onSave: (ArticleItem) -> Void
  private let onShowExistingLink: () -> Void
  
  @Environment(\.modelContext) private var modelContext
  
  @State private var linkURL: String = ""
  @State private var selectedCategoryID: UUID?
  @State private var isSaving: Bool = false
  @State private var statusMessage: String?
  @State private var isStatusError: Bool = false
  @State private var isDuplicateLinkToastPresented: Bool = false
  
  public init(
    categories: [CategoryItem] = [],
    totalLinkCount: Int = 0,
    onSave: @escaping (ArticleItem) -> Void = { _ in },
    onShowExistingLink: @escaping () -> Void = {}
  ) {
    self.categories = categories
    self.totalLinkCount = totalLinkCount
    self.onSave = onSave
    self.onShowExistingLink = onShowExistingLink
  }
  
  public var body: some View {
    ZStack(alignment: .top) {
      AddLinkMainContentView(
        categories: categories,
        totalLinkCount: totalLinkCount,
        isSaving: isSaving,
        canSubmit: canSubmit,
        onAdd: addButtonTapped,
        onAddCategory: addCategoryButtonTapped,
        onLinkURLChanged: linkURLChanged,
        linkURL: $linkURL,
        selectedCategoryID: $selectedCategoryID
      )
      
      AddLinkToastLayer(
        isDuplicateLinkToastPresented: isDuplicateLinkToastPresented,
        statusMessage: statusMessage,
        isStatusError: isStatusError,
        onShowExistingLink: showExistingLink,
        onCloseDuplicateToast: closeDuplicateToast,
        onCloseStatusToast: closeStatusToast
      )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.background)
    .task(id: linkURL) {
      await checkDuplicateLink(for: linkURL)
    }
  }
}

private extension AddLinkView {
  var isAddButtonEnabled: Bool {
    !linkURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
  
  var canSubmit: Bool {
    isAddButtonEnabled && !isSaving && !isDuplicateLinkToastPresented
  }
  
  func selectedCategory() -> CategoryItem? {
    guard let selectedCategoryID else { return nil }
    return categories.first { $0.id == selectedCategoryID }
  }
  
  func addButtonTapped() {
    Task {
      await saveLink()
    }
  }
  
  func addCategoryButtonTapped() {}
  
  func linkURLChanged() {
    statusMessage = nil
    isDuplicateLinkToastPresented = false
  }
  
  func showExistingLink() {
    isDuplicateLinkToastPresented = false
    onShowExistingLink()
  }
  
  func closeDuplicateToast() {
    isDuplicateLinkToastPresented = false
  }
  
  func closeStatusToast() {
    statusMessage = nil
  }
  
  @MainActor
  func checkDuplicateLink(for rawURLString: String) async {
    try? await Task.sleep(nanoseconds: 300_000_000)
    guard !Task.isCancelled else { return }
    
    let normalizedURLString = normalizedURLString(from: rawURLString)
    guard isValidURLString(normalizedURLString) else {
      isDuplicateLinkToastPresented = false
      return
    }
    
    do {
      isDuplicateLinkToastPresented = try LinkService.shared.urlExists(normalizedURLString)
    } catch {
      isDuplicateLinkToastPresented = false
    }
  }
  
  @MainActor
  func saveLink() async {
    let normalizedURLString = normalizedURLString(from: linkURL)
    
    guard isValidURLString(normalizedURLString), let url = URL(string: normalizedURLString) else {
      showStatus("올바른 링크를 입력해주세요", isError: true)
      return
    }
    
    isSaving = true
    defer { isSaving = false }
    
    do {
      if try LinkService.shared.urlExists(normalizedURLString) {
        statusMessage = nil
        isDuplicateLinkToastPresented = true
        return
      }
      
      let metadata = try await LinkService.shared.extractMetadata(from: url)
      let selectedCategory = selectedCategory()
      let article = ArticleItem(
        urlString: normalizedURLString,
        title: metadata.title,
        imageURL: metadata.imageURL?.absoluteString
      )
      article.category = selectedCategory
      
      modelContext.insert(article)
      try modelContext.save()
      
      linkURL = ""
      selectedCategoryID = nil
      statusMessage = nil
      isDuplicateLinkToastPresented = false
      onSave(article)
    } catch {
      showStatus("링크를 불러올 수 없어요", isError: true)
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
  
  func isValidURLString(_ urlString: String) -> Bool {
    guard let url = URL(string: urlString) else { return false }
    return url.scheme != nil && url.host != nil
  }
  
  func showStatus(_ message: String, isError: Bool) {
    statusMessage = message
    isStatusError = isError
    
    if isError {
      isDuplicateLinkToastPresented = false
    }
  }
}
