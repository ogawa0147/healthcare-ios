import Foundation

public protocol DatabaseType: class {
    var locationDatabase: LocationDatabaseType { get }
}
