import Foundation
import SwiftData

// MARK: - TapTap Schema Versions

public enum TapTapSchemaV1: VersionedSchema {
  public static var versionIdentifier: Schema.Version = .init(1, 0, 0)
  public static var models: [any PersistentModel.Type] {
    [ArticleItem.self, HighlightItem.self, CategoryItem.self]
  }

  @Model
  public final class ArticleItem {
    @Attribute(.unique) public var id: String
    @Attribute(.unique) public var urlString: String
    public var title: String
    public var createAt: Date
    public var lastViewedDate: Date
    public var category: CategoryItem?
    public var userMemo: String
    public var imageURL: String?
    @Relationship(deleteRule: .cascade) public var highlights: [HighlightItem] = []

    public init(id: String, urlString: String, title: String, createAt: Date, lastViewedDate: Date, userMemo: String, imageURL: String?) {
      self.id = id
      self.urlString = urlString
      self.title = title
      self.createAt = createAt
      self.lastViewedDate = lastViewedDate
      self.userMemo = userMemo
      self.imageURL = imageURL
    }
  }

  @Model
  public final class HighlightItem {
    @Attribute(.unique) public var id: String
    public var sentence: String
    public var type: String
    public var createdAt: Date
    public var commentsJSON: String = "[]"
    public var link: ArticleItem?

    public init(id: String, sentence: String, type: String, createdAt: Date) {
      self.id = id
      self.sentence = sentence
      self.type = type
      self.createdAt = createdAt
    }
  }

  @Model
  public final class CategoryItem {
    @Attribute(.unique) public var id: UUID
    @Attribute(.unique) public var categoryName: String
    public var createdAt: Date
    public var iconNumber: Int
    @Relationship(inverse: \ArticleItem.category) public var links: [ArticleItem] = []

    public init(id: UUID, categoryName: String, createdAt: Date, iconNumber: Int) {
      self.id = id
      self.categoryName = categoryName
      self.createdAt = createdAt
      self.iconNumber = iconNumber
    }
  }
}

public enum TapTapSchemaV2: VersionedSchema {
  public static var versionIdentifier: Schema.Version = .init(1, 1, 0)
  public static var models: [any PersistentModel.Type] {
    [ArticleItem.self, HighlightItem.self, CategoryItem.self]
  }

  @Model
  public final class ArticleItem: Codable, Sendable {
    public var id: String = UUID().uuidString
    public var urlString: String = ""
    public var title: String = ""
    public var createAt: Date = Date()
    public var lastViewedDate: Date = Date()
    public var category: CategoryItem?
    public var userMemo: String = ""
    public var imageURL: String?
    @Relationship(deleteRule: .cascade) public var highlights: [HighlightItem]? = []

    public init(urlString: String, title: String, lastViewedDate: Date = Date(), imageURL: String? = nil) {
      self.id = UUID().uuidString
      self.urlString = urlString
      self.title = title
      self.createAt = Date()
      self.lastViewedDate = lastViewedDate
      self.imageURL = imageURL
    }

    enum CodingKeys: CodingKey {
      case id, urlString, title, createAt, lastViewedDate, userMemo, imageURL, category, highlights
    }

    public required init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decode(String.self, forKey: .id)
      self.urlString = try container.decode(String.self, forKey: .urlString)
      self.title = try container.decode(String.self, forKey: .title)
      self.createAt = try container.decode(Date.self, forKey: .createAt)
      self.lastViewedDate = try container.decode(Date.self, forKey: .lastViewedDate)
      self.userMemo = try container.decode(String.self, forKey: .userMemo)
      self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
      self.category = try container.decodeIfPresent(CategoryItem.self, forKey: .category)
      self.highlights = try container.decodeIfPresent([HighlightItem].self, forKey: .highlights) ?? []
    }

    public func encode(to encoder: any Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(urlString, forKey: .urlString)
      try container.encode(title, forKey: .title)
      try container.encode(createAt, forKey: .createAt)
      try container.encode(lastViewedDate, forKey: .lastViewedDate)
      try container.encode(userMemo, forKey: .userMemo)
      try container.encodeIfPresent(imageURL, forKey: .imageURL)
      try container.encodeIfPresent(category, forKey: .category)
      try container.encode(highlights ?? [], forKey: .highlights)
    }
  }

  @Model
  public final class HighlightItem: Codable, Identifiable {
    public var id: String = UUID().uuidString
    public var sentence: String = ""
    public var type: String = ""
    public var createdAt: Date = Date()
    @Attribute(originalName: "comments_json") private var commentsJSON: String = "[]"
    public var link: ArticleItem?

    public var comments: [Comment] {
      get {
        guard let data = commentsJSON.data(using: .utf8),
              let decodedComments = try? JSONDecoder().decode([Comment].self, from: data) else {
          return []
        }
        return decodedComments
      }
      set {
        guard let data = try? JSONEncoder().encode(newValue),
              let jsonString = String(data: data, encoding: .utf8) else {
          commentsJSON = "[]"
          return
        }
        commentsJSON = jsonString
      }
    }

    public init(id: String, sentence: String, type: String, createdAt: Date, comments: [Comment] = []) {
      self.id = id
      self.sentence = sentence
      self.type = type
      self.createdAt = createdAt
      self.comments = comments
    }

    enum CodingKeys: CodingKey {
      case id, sentence, type, createdAt, commentsJSON
    }

    public required init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decode(String.self, forKey: .id)
      self.sentence = try container.decode(String.self, forKey: .sentence)
      self.type = try container.decode(String.self, forKey: .type)
      self.createdAt = try container.decode(Date.self, forKey: .createdAt)
      self.commentsJSON = try container.decode(String.self, forKey: .commentsJSON)
    }

    public func encode(to encoder: any Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(sentence, forKey: .sentence)
      try container.encode(type, forKey: .type)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(commentsJSON, forKey: .commentsJSON)
    }
  }

  @Model
  public final class CategoryItem: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID = UUID()
    public var categoryName: String = ""
    public var createdAt: Date = Date()
    public var icon: CategoryIcon = CategoryIcon()
    @Relationship(inverse: \ArticleItem.category) public var links: [ArticleItem]? = []

    public init(categoryName: String, icon: CategoryIcon) {
      self.id = UUID()
      self.categoryName = categoryName
      self.createdAt = Date()
      self.icon = icon
    }

    enum CodingKeys: String, CodingKey {
      case id, categoryName, createdAt, icon
    }

    public required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decode(UUID.self, forKey: .id)
      self.categoryName = try container.decode(String.self, forKey: .categoryName)
      self.createdAt = try container.decode(Date.self, forKey: .createdAt)
      self.icon = try container.decode(CategoryIcon.self, forKey: .icon)
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(categoryName, forKey: .categoryName)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(icon, forKey: .icon)
    }
  }
}

// MARK: - Migration Plan

public enum TapTapMigrationPlan: SchemaMigrationPlan {
  public static var schemas: [any VersionedSchema.Type] {
    [TapTapSchemaV1.self, TapTapSchemaV2.self]
  }

  public static var stages: [MigrationStage] {
    [migrateV1toV2]
  }

  public static let migrateV1toV2 = MigrationStage.lightweight(
    fromVersion: TapTapSchemaV1.self,
    toVersion: TapTapSchemaV2.self
  )
}

// MARK: - Typealiases

public typealias ArticleItem = TapTapSchemaV2.ArticleItem
public typealias HighlightItem = TapTapSchemaV2.HighlightItem
public typealias CategoryItem = TapTapSchemaV2.CategoryItem
