import Foundation

public struct Location {
    public let id: ID
    public let latitude: Double
    public let longitude: Double
    public let altitude: Double
    public let speed: Double
    public let horizontalAccuracy: Double
    public let verticalAccuracy: Double
    public let timestamp: Int64

    public init(id: ID, latitude: Double, longitude: Double, altitude: Double, speed: Double, verticalAccuracy: Double, horizontalAccuracy: Double, timestamp: Int64) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.speed = speed
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
        self.timestamp = timestamp
    }
}
