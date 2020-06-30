import UIKit
import GoogleMaps

// https://developers.google.com/maps/documentation/ios-sdk/intro
// https://codeday.me/jp/qa/20190910/1579824.html

final class GoogleMapView: UIView {
    private var constants: GoogleMapConstants = GoogleMapConstants()

    private var mapView: GMSMapView!
    private var camera: GMSCameraPosition!

    private var polyline: GMSPolyline?
    private var markers: [GMSMarker]?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func configure() {
        self.camera = GMSCameraPosition.camera(withLatitude: constants.defaultLatitude, longitude: constants.defaultLongitude, zoom: constants.defaultZoomLevel)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)

        if let jsonString = String(data: Asset.Assets.googleMapStyle.data.data, encoding: .utf8), let mapStyle = try? GMSMapStyle(jsonString: jsonString) {
            mapView.mapStyle = mapStyle
        }

        mapView.mapType = constants.mapType

        removeFromSuperview()

        addSubview(mapView)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        mapView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        mapView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
    }

    func setConstants(_ constants: GoogleMapConstants) {
        self.constants = constants
    }

    func drawRoute(at coordinates: [CLLocationCoordinate2D]) {
        configurePolyline(at: coordinates)
        scaleMapToFitLocation(at: coordinates)
    }

    func drawMarkers(_ attributes: [GoogleMapMarkerAttribute]) {
        markers?.forEach { $0.map = nil }
        markers = attributes.map {
            let marker = GMSMarker(position: $0.position)
            marker.icon = $0.icon
            marker.title = $0.title
            marker.snippet = $0.snippet
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            return marker
        }
        markers?.forEach { $0.map = mapView }
    }

    func clear() {
        mapView.clear()
        markers?.forEach { $0.map = nil }
        markers?.removeAll()
        polyline?.map = nil
    }

    func delay(seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }

    private func configurePolyline(at coordinates: [CLLocationCoordinate2D]) {
        polyline?.map = nil
        let path: GMSMutablePath = .init()
        coordinates.forEach {
            path.addLatitude($0.latitude, longitude: $0.longitude)
        }
        polyline = GMSPolyline(path: path)
        polyline?.strokeColor = constants.polylineStrokeColor
        polyline?.strokeWidth = constants.polylineStrokeWidth
        polyline?.map = mapView
    }

    private func scaleMapToFitLocation(at coordinates: [CLLocationCoordinate2D]) {
        let bounds = coordinates.reduce(GMSCoordinateBounds()) {
            $0.includingCoordinate(.init(latitude: $1.latitude, longitude: $1.longitude))
        }
        mapView.animate(with: .fit(bounds, withPadding: constants.boundPadding))
    }
}
