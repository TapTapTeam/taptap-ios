//
//  ImageCache.swift
//  DesignSystem
//
//  Created by 홍 on 4/23/26.
//

#if os(iOS)
import UIKit
import CryptoKit

@MainActor
public final class ImageCache {
  
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
    let cost = memoryCost(for: image)
    let fileURL = diskURL(forKey: key)
    
    memoryCache.setObject(image, forKey: cacheKey, cost: cost)
    ioQueue.async {
      guard let data = image.jpegData(compressionQuality: 0.8) else { return }
      try? data.write(to: fileURL, options: .atomic)
    }
  }
  
  public func memoryImage(forKey key: String) -> UIImage? {
    memoryCache.object(forKey: key as NSString)
  }
  
  public func retrieveImage(forKey key: String) async -> UIImage? {
    let cacheKey = key as NSString
    let fileURL = diskURL(forKey: key)
    
    if let image = memoryCache.object(forKey: cacheKey) {
      return image
    }
    
    guard let image = await withCheckedContinuation({
      (continuation: CheckedContinuation<UIImage?, Never>) in
      
      ioQueue.async {
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
          continuation.resume(returning: nil)
          return
        }
        
        continuation.resume(returning: image)
      }
    }) else {
      return nil
    }
    
    memoryCache.setObject(
      image,
      forKey: cacheKey,
      cost: memoryCost(for: image)
    )
    
    return image
  }
  
  @objc public func clearMemoryCache() {
    memoryCache.removeAllObjects()
  }
  
  public func clearDiskCache() {
    let diskCacheURL = self.diskCacheURL
    
    ioQueue.async {
      let files = try? FileManager.default.contentsOfDirectory(
        at: diskCacheURL,
        includingPropertiesForKeys: nil
      )
      
      files?.forEach {
        try? FileManager.default.removeItem(at: $0)
      }
    }
  }
  
  private func diskURL(forKey key: String) -> URL {
    let data = Data(key.utf8)
    let hash = SHA256.hash(data: data)
    let fileName = hash.compactMap { String(format: "%02x", $0) }.joined()
    return diskCacheURL.appendingPathComponent(fileName)
  }
  
  private func memoryCost(for image: UIImage) -> Int {
    guard let cgImage = image.cgImage else { return 0 }
    return cgImage.bytesPerRow * cgImage.height
  }
}
#endif
