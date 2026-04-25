import Foundation
import SwiftData

public enum AppGroupContainer {
  public static let shared: ModelContainer = {
    let appGroupID = "group.com.nbs.dev.ADA.shared"
    let schema = Schema(versionedSchema: TapTapSchemaV2.self)
    
    guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
      fatalError("Failed to find App Group container.")
    }
    
    let storeURL = containerURL.appendingPathComponent("Nbs_store.sqlite")
    let isExtension = Bundle.main.bundleURL.pathExtension == "appex"
    let configuration = ModelConfiguration(
      schema: schema,
      url: storeURL,
      cloudKitDatabase: isExtension ? .none : .automatic
    )
    
    do {
      return try ModelContainer(
        for: schema,
        migrationPlan: TapTapMigrationPlan.self,
        configurations: [configuration]
      )
    } catch {
      print("SwiftData Migration Error: \(error)")
      fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
    }
  }()
}
