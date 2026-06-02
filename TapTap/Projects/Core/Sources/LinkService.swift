//
//  LinkService.swift
//  Core
//
//  Created by 홍 on 05/29/26.
//

import Foundation
import SwiftData

public struct LinkMetadata: Sendable {
  public let title: String
  public let imageURL: URL?
  
  public init(title: String, imageURL: URL?) {
    self.title = title
    self.imageURL = imageURL
  }
}

public final class LinkService: Sendable {
  public static let shared = LinkService()
  
  private init() {}
  
  public func extractMetadata(from url: URL) async throws -> LinkMetadata {
    let htmlString = try await fetchHTML(from: url)
    let title = try extractTitle(from: htmlString)
    let imageURL = extractImageURL(from: htmlString, baseURL: url)
    return LinkMetadata(title: title, imageURL: imageURL)
  }
  
  private func fetchHTML(from url: URL) async throws -> String {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let htmlString = String(data: data, encoding: .utf8) else {
      throw URLError(.cannotDecodeContentData)
    }
    return htmlString
  }
  
  private func extractTitle(from htmlString: String) throws -> String {
    let regex = try NSRegularExpression(pattern: "<title[^>]*>(.*?)</title>", options: [.caseInsensitive, .dotMatchesLineSeparators])
    if let match = regex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)) {
      if let titleRange = Range(match.range(at: 1), in: htmlString) {
        let title = String(htmlString[titleRange]).trimmingCharacters(in: .whitespacesAndNewlines)
        return title.decodeHtmlEntities()
      }
    }
    throw URLError(.cannotParseResponse)
  }
  
  private func extractImageURL(from htmlString: String, baseURL: URL) -> URL? {
    guard let metaRegex = try? NSRegularExpression(
      pattern: "<meta\\b[^>]*>",
      options: [.caseInsensitive, .dotMatchesLineSeparators]
    ) else { return nil }
    
    let metaMatches = metaRegex.matches(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count))
    for match in metaMatches {
      guard let range = Range(match.range, in: htmlString) else { continue }
      let attributes = Self.htmlAttributes(from: String(htmlString[range]))
      let property = attributes["property"] ?? attributes["name"]
      
      if property?.lowercased() == "og:image",
         let imageUrlString = attributes["content"],
         let imageUrl = URL(string: imageUrlString, relativeTo: baseURL) {
        return imageUrl
      }
    }
    
    guard let imgRegex = try? NSRegularExpression(
      pattern: "<img[^>]*src=[\"']([^\"']+)[\"'][^>]*>",
      options: [.caseInsensitive, .dotMatchesLineSeparators]
    ) else { return nil }
    
    if let match = imgRegex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)),
       let range = Range(match.range(at: 1), in: htmlString) {
      let imageUrlString = String(htmlString[range])
      if let imageUrl = URL(string: imageUrlString, relativeTo: baseURL) {
        return imageUrl
      }
    }
    
    return nil
  }
  
  private static func htmlAttributes(from tag: String) -> [String: String] {
    guard let attributeRegex = try? NSRegularExpression(
      pattern: #"([A-Za-z_:][-A-Za-z0-9_:.]*)\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s"'>]+))"#,
      options: [.caseInsensitive]
    ) else { return [:] }
    
    var attributes: [String: String] = [:]
    let matches = attributeRegex.matches(in: tag, range: NSRange(tag.startIndex..., in: tag))
    for match in matches {
      guard let keyRange = Range(match.range(at: 1), in: tag) else { continue }
      
      let valueRange = (2..<5)
        .map { match.range(at: $0) }
        .first { $0.location != NSNotFound }
        .flatMap { Range($0, in: tag) }
      
      guard let valueRange else { continue }
      attributes[String(tag[keyRange]).lowercased()] = String(tag[valueRange]).decodeHtmlEntities()
    }
    return attributes
  }
  
  @MainActor
  public func urlExists(_ urlString: String) throws -> Bool {
    let container = AppGroupContainer.shared
    let context = container.mainContext
    let fetchDescriptor = FetchDescriptor<ArticleItem>(
      predicate: #Predicate { $0.urlString == urlString }
    )
    return try context.fetch(fetchDescriptor).first != nil
  }
}

extension String {
  func decodeHtmlEntities() -> String {
    var decoded = self
    let namedEntities: [String: String] = [
      "&amp;": "&",
      "&quot;": "\"",
      "&#39;": "'",
      "&apos;": "'",
      "&lt;": "<",
      "&gt;": ">",
      "&nbsp;": " "
    ]
    
    for (entity, value) in namedEntities {
      decoded = decoded.replacingOccurrences(of: entity, with: value)
    }
    
    decoded = decoded.replacingNumericHtmlEntities(radix: 10, pattern: #"&#(\d+);"#)
    decoded = decoded.replacingNumericHtmlEntities(radix: 16, pattern: #"&#x([0-9a-fA-F]+);"#)
    return decoded
  }
  
  private func replacingNumericHtmlEntities(radix: Int, pattern: String) -> String {
    guard let regex = try? NSRegularExpression(pattern: pattern) else {
      return self
    }
    
    var result = self
    let matches = regex.matches(in: self, range: NSRange(startIndex..., in: self))
    for match in matches.reversed() {
      guard
        let fullRange = Range(match.range(at: 0), in: result),
        let valueRange = Range(match.range(at: 1), in: result),
        let scalarValue = UInt32(result[valueRange], radix: radix),
        let scalar = UnicodeScalar(scalarValue)
      else { continue }
      
      result.replaceSubrange(fullRange, with: String(scalar))
    }
    return result
  }
}
