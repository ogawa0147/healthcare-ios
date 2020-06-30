import UIKit
import GoogleMaps

struct GoogleMapConstants {
    let defaultLatitude: Double = 0
    let defaultLongitude: Double = 0
    let defaultZoomLevel: Float = 13
    let polylineStrokeColor: UIColor
    let polylineStrokeWidth: CGFloat
    let mapType: GMSMapViewType
    let boundPadding: CGFloat

    init(polylineStrokeColor: UIColor = Asset.Colors.darkThemeLabel.color,
         polylineStrokeWidth: CGFloat = 5.0,
         mapType: GMSMapViewType = .normal,
         boundPadding: CGFloat = 30.0
        ) {
        self.polylineStrokeColor = polylineStrokeColor
        self.polylineStrokeWidth = polylineStrokeWidth
        self.mapType = mapType
        self.boundPadding = boundPadding
    }
}
