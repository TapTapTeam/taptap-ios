//
//  ImageCache.swift
//  DesignSystem
//
//  Created by 홍 on 4/23/26.
//

#if os(iOS)
import UIKit

public final class ImageCache: @unchecked Sendable {
  
  public static let shared = ImageCache()
  
  private let memoryCache: NSCache<NSString, UIImage> = {
    let cache = NSCache<NSString, UIImage>()
    cache.totalCostLimit = 50 * 1024 * 1024
    cache.countLimit = 100
    return cache
  }()
  
  private let diskCacheURL: URL = {
    let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let dir = caches.appendingPathComponent("ImageCache", isDirectory: true)
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    return dir
  }()
  
  private let ioQueue = DispatchQueue(label: "com.taptap.imagecache.io", qos: .utility)
  
  private init() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(clearMemoryCache),
      name: UIApplication.didReceiveMemoryWarningNotification,
      object: nil
    )
  }
  
  public func store(_ image: UIImage, forKey key: String) {
    let cacheKey = key as NSString
    
    memoryCache.setObject(image, forKey: cacheKey, cost: memoryCost(for: image))
    
    ioQueue.async { [weak self] in
      guard let self, let data = image.jpegData(compressionQuality: 0.8) else { return }
      let fileURL = self.diskURL(forKey: key)
      try? data.write(to: fileURL, options: .atomic)
    }
  }
  
  // MARK: - Retrieve
  /// 메모리 → 디스크 순으로 이미지를 조회합니다.
  public func retrieveImage(forKey key: String) -> UIImage? {
    let cacheKey = key as NSString
    
    if let image = memoryCache.object(forKey: cacheKey) {
      return image
    }
    
    let fileURL = diskURL(forKey: key)
    guard let data = try? Data(contentsOf: fileURL),
          let image = UIImage(data: data) else { return nil }
    
    memoryCache.setObject(image, forKey: cacheKey, cost: memoryCost(for: image))
    return image
  }
  
  @objc public func clearMemoryCache() {
    memoryCache.removeAllObjects()
  }
  
  public func clearDiskCache() {
    ioQueue.async { [weak self] in
      guard let self else { return }
      let files = try? FileManager.default.contentsOfDirectory(
        at: self.diskCacheURL,
        includingPropertiesForKeys: nil
      )
      files?.forEach { try? FileManager.default.removeItem(at: $0) }
    }
  }
  
  // MARK: - Helpers
  private func diskURL(forKey key: String) -> URL {
    let fileName = key
      .addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
    return diskCacheURL.appendingPathComponent(fileName)
  }
  
  private func memoryCost(for image: UIImage) -> Int {
    guard let cgImage = image.cgImage else { return 0 }
    return cgImage.bytesPerRow * cgImage.height
  }
}
#endif
