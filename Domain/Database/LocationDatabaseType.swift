import Foundation

public protocol LocationDatabaseType: class {
    func find(by id: ID) -> [Location]
    func findAll() -> [Location]

    func save(_ object: Location)
    func save(_ objects: [Location])

    func delete(by id: ID)
    func deleteAll()
}
