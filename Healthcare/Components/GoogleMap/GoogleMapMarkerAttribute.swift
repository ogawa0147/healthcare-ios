import UIKit
import GoogleMaps

struct GoogleMapMarkerAttribute {
    let position: CLLocationCoordinate2D
    let icon: UIImage?
    let title: String?
    let snippet: String?

    init(position: CLLocationCoordinate2D,
         icon: UIImage? = nil,
         title: String? = nil,
         snippet: String? = nil
        ) {
        self.position = position
        self.icon = icon
        self.title = title
        self.snippet = snippet
    }
}
