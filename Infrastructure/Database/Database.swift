import Foundation
import RealmSwift
import Domain
import Environments

public final class Database: Domain.DatabaseType {
    public let locationDatabase: Domain.LocationDatabaseType

    public init() {
        let documentURL = URL(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])!
        let fileURL = documentURL.appendingPathComponent("\(Constants.identifier).realm")

        var configuration = Realm.Configuration()
        configuration.fileURL = fileURL
        configuration.schemaVersion = 0
        configuration.migrationBlock = { _, oldSchemaVersion in
            if oldSchemaVersion < 0 {
            }
        }

        let realm = try! Realm(configuration: configuration)
        try! FileManager.default.setAttributes([FileAttributeKey(rawValue: FileAttributeKey.protectionKey.rawValue): FileProtectionType.none], ofItemAtPath: fileURL.path)

        self.locationDatabase = LocationDatabase(realm: realm)
    }
}
