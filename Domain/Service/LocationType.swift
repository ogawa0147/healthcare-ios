import Foundation

public protocol LocationType {
    var delegate: LocationDelegate? { get set }

    func authorizationStatus() -> LocationAuthorizationStatus
    func requestAuthorization()

    func startLocation(id: ID)
    func stopLocation()
}

public protocol LocationDelegate: class {
    func didUpdateLocations(_ locations: [Location])
}
