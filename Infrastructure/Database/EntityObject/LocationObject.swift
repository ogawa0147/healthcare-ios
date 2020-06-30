import Foundation
import RealmSwift
import struct Domain.ID
import struct Domain.Location
import protocol Domain.DomainObjectConvertibleType

final class LocationObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var altitude: Double = 0.0
    @objc dynamic var speed: Double = 0.0
    @objc dynamic var horizontalAccuracy: Double = 0.0
    @objc dynamic var verticalAccuracy: Double = 0.0
    @objc dynamic var timestamp: Int64 = 0

    convenience init(location: Domain.Location) {
        self.init()
        id = location.id.rawValue
        latitude = location.latitude
        longitude = location.longitude
        altitude = location.altitude
        speed = location.speed
        horizontalAccuracy = location.horizontalAccuracy
        verticalAccuracy = location.verticalAccuracy
        timestamp = location.timestamp
    }
}

extension LocationObject: Domain.DomainObjectConvertibleType {
    func toDomainObject() -> Domain.Location {
        return .init(
            id: Domain.ID(rawValue: id),
            latitude: latitude,
            longitude: longitude,
            altitude: altitude,
            speed: speed,
            verticalAccuracy: horizontalAccuracy,
            horizontalAccuracy: verticalAccuracy,
            timestamp: timestamp
        )
    }
}

extension Domain.Location: EntityObjectConvertibleType {
    func toEntityObject() -> LocationObject {
        return LocationObject.build { object in
            object.id = id.rawValue
            object.latitude = latitude
            object.longitude = longitude
            object.altitude = altitude
            object.speed = speed
            object.verticalAccuracy = verticalAccuracy
            object.horizontalAccuracy = horizontalAccuracy
            object.timestamp = timestamp
        }
    }
}
