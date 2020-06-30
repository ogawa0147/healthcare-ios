import Foundation
import CoreLocation
import Domain

public final class LocationService: NSObject, Domain.LocationType {
    private let manager: CLLocationManager
    private var id: Domain.ID?

    public weak var delegate: Domain.LocationDelegate?

    public override init() {
        self.manager = CLLocationManager()
        self.manager.allowsBackgroundLocationUpdates = true
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = 1

        super.init()

        self.manager.delegate = self
    }

    public func authorizationStatus() -> Domain.LocationAuthorizationStatus {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            return .authorizedAlways
        case .authorizedWhenInUse:
            return .authorizedWhenInUse
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        default:
            fatalError()
        }
    }

    public func requestAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    public func startLocation(id: Domain.ID) {
        self.id = id
        manager.startUpdatingLocation()
    }

    public func stopLocation() {
        manager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let id = id else {
            return
        }

        let toLocations: [Domain.Location] = locations.map { location in
            return .init(
                id: id,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                altitude: location.altitude,
                speed: location.speed,
                verticalAccuracy: location.horizontalAccuracy,
                horizontalAccuracy: location.verticalAccuracy,
                timestamp: Int64(Date().timeIntervalSince1970)
            )
        }

        delegate?.didUpdateLocations(toLocations)
    }
}
