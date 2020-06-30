import UIKit
import SwiftDate
import Nuke

final class GoogleStaticMapView: UIView {
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear

        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
    }

    func bind(encodedPolyline: String, startLatitude: Double, startLongitude: Double, endLatitude: Double, endLongitude: Double) {
        let url = GoogleStaticMapConstants.baseURL
            .appending("key", value: GoogleStaticMapConstants.apiKey)
            .appending("size", value: GoogleStaticMapConstants.toSize(bounds.size))
            .appending("scale", value: GoogleStaticMapConstants.scale)
            .appending("maptype", value: GoogleStaticMapConstants.mapType)
            .appending("style", values: GoogleStaticMapConstants.style)
            .appending("path", value: GoogleStaticMapConstants.toPath(encodedPolyline: encodedPolyline))
            .appending("markers", values: GoogleStaticMapConstants.toMarkers(startLatitude: startLatitude, startLongitude: startLongitude, endLatitude: endLatitude, endLongitude: endLongitude))
            .appending("language", value: SwiftDate.defaultRegion.locale.languageCode)
        let request = ImageRequest(url: url)
        Nuke.loadImage(with: request, options: .init(), into: imageView)
    }
}
