import UIKit

final class LocationItemCell: UICollectionViewCell, NibReusable {
    struct Dependency {
        let elements: [LocationViewModel.Element]
    }

    @IBOutlet weak private var mapView: GoogleStaticMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }

    private func commonInit() {
    }

    func bind(_ dependency: Dependency) {
        let coordinates = dependency.elements.map { $0.coordinate }
        let polyline = Polyline(coordinates: coordinates)
        let encodedPolyline: String = polyline.encodedPolyline

        mapView.bind(encodedPolyline: encodedPolyline, startLatitude: 0, startLongitude: 0, endLatitude: 0, endLongitude: 0)
    }
}
