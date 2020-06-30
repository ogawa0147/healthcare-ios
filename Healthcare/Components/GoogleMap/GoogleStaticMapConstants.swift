import Foundation
import Environments

// https://github.com/kean/Nuke
// https://developers.google.com/maps/documentation/maps-static/dev-guide
// https://developers.google.com/maps/documentation/maps-static/dev-guide#Imagesizes
// https://developers.google.com/maps/documentation/maps-static/dev-guide#MapTypes
// https://developers.google.com/maps/documentation/maps-static/dev-guide#scale_values
// https://developers.google.com/maps/documentation/maps-static/dev-guide#Paths
// https://developers.google.com/maps/documentation/maps-static/styling
// https://developers.google.com/maps/documentation/maps-static/dev-guide#Markers

struct GoogleStaticMapConstants {
    private enum MapType: String {
        case roadmap, satellite, hybrid, terrain
    }

    private enum AnchorType: String {
        case top, bottom, left, right, center, topleft, topright, bottomleft, bottomright
    }

    static var baseURL: URL {
        return Constants.GoogleService.staticMapURL
    }

    static var apiKey: String {
        return Constants.GoogleService.apiKey
    }

    static func toSize(_ size: CGSize) -> String {
        return String(format: "%.0fx%.0f", size.width, size.height)
    }

    static var scale: String {
        return "2"
    }

    static var mapType: String {
        return MapType.roadmap.rawValue
    }

    static var style: [String] {
        return [
            "element:labels.text.fill|color:0x999999|saturation:36|lightness:40",
            "element:labels.text.stroke|color:0xffffff|lightness:16",
            "feature:administrative|element:geometry|saturation:-100",
            "feature:administrative.locality|element:labels.text|visibility:on",
            "feature:landscape.man_made|element:geometry|color:0xf1f1f1",
            "feature:landscape.natural|element:geometry.fill|color:0x9bd776|saturation:-40|lightness:70",
            "feature:poi|element:geometry|color:0xf1f1f1|lightness:21",
            "feature:poi|element:labels|visibility:on",
            "feature:poi.park|element:geometry|color:0xBAD776|saturation:-40|lightness:70",
            "feature:road|element:geometry|color:0xffffff",
            "feature:road|element:labels.icon|saturation:-100|lightness:35",
            "feature:transit|element:geometry|color:0xcccccc",
            "feature:water|element:geometry|color:0x6dd9e2|saturation:-40|lightness:70"
        ]
    }

    static func toPath(encodedPolyline: String) -> String {
        return String(format: "weight:3|color:0x0CB9ACFF|enc:%@", encodedPolyline)
    }

    static func toMarkers(startLatitude: Double, startLongitude: Double, endLatitude: Double, endLongitude: Double) -> [String] {
        return [
            String(format: "anchor:%@|scale:%@|%f,%f|", AnchorType.center.rawValue, scale, startLatitude, startLongitude),
            String(format: "anchor:%@|scale:%@|%f,%f|", AnchorType.center.rawValue, scale, endLatitude, endLongitude)
        ]
    }
}
