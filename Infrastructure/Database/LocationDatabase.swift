import Foundation
import RealmSwift
import Domain
import Logger

final class LocationDatabase: Domain.LocationDatabaseType {
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func find(by id: Domain.ID) -> [Domain.Location] {
        return realm.objects(LocationObject.self).filter("id = %@", id.rawValue).map { $0.toDomainObject() }
    }

    func findAll() -> [Domain.Location] {
        return realm.objects(LocationObject.self).map { $0.toDomainObject() }
    }

    func save(_ object: Domain.Location) {
        do {
            try realm.write {
                realm.add(object.toEntityObject(), update: .modified)
            }
        } catch let error {
            Logger.error(error)
        }
    }

    func save(_ objects: [Domain.Location]) {
        do {
            try realm.write {
                realm.add(objects.map { $0.toEntityObject() }, update: .error)
            }
        } catch let error {
            Logger.error(error)
        }
    }

    func delete(by id: ID) {
        do {
            let object = realm.objects(LocationObject.self).filter("id == %@", id.rawValue)
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            Logger.error(error)
        }
    }

    func deleteAll() {
        do {
            try realm.write {
                realm.delete(realm.objects(LocationObject.self))
            }
        } catch let error {
            Logger.error(error)
        }
    }
}
