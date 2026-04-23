//
//  CachedAsyncImage.swift
//  DesignSystem
//
//  Created by 홍 on 4/23/26.
//

#if os(iOS)
import SwiftUI

private enum CachedImageState {
  case loading
  case success(Image)
  case failure
}

public struct CachedAsyncImage<Content: View>: View {
  
  private let url: URL?
  private let content: (CachedImagePhase) -> Content
  @State private var state: CachedImageState = .loading
  
  public init(
    url: URL?,
    @ViewBuilder content: @escaping (CachedImagePhase) -> Content
  ) {
    self.url = url
    self.content = content
  }
  
  public var body: some View {
    Group {
      switch state {
      case .loading:
        content(.empty)
      case .success(let image):
        content(.success(image))
      case .failure:
        content(.failure)
      }
    }
    .onAppear {
      checkMemoryCache()
    }
    .task(id: url?.absoluteString) {
      await loadImage()
    }
  }
  
  // MARK: - Load
  private func checkMemoryCache() {
    guard let key = url?.absoluteString,
          let image = ImageCache.shared.memoryImage(forKey: key) else { return }
    state = .success(Image(uiImage: image))
  }
  
  @MainActor
  private func loadImage() async {
    guard let url else {
      state = .failure
      return
    }
    
    let key = url.absoluteString
    
    if let image = ImageCache.shared.memoryImage(forKey: key) {
      state = .success(Image(uiImage: image))
      return
    }
    
    state = .loading
    
    if let cached = await ImageCache.shared.retrieveImage(forKey: key) {
      guard !Task.isCancelled else { return }
      state = .success(Image(uiImage: cached))
      return
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      guard !Task.isCancelled else { return }
      
      guard let uiImage = UIImage(data: data) else {
        state = .failure
        return
      }
      
      ImageCache.shared.store(uiImage, forKey: key)
      state = .success(Image(uiImage: uiImage))
    } catch {
      guard !Task.isCancelled else { return }
      state = .failure
    }
  }
}

public enum CachedImagePhase {
  case empty
  case success(Image)
  case failure
}
#endif
