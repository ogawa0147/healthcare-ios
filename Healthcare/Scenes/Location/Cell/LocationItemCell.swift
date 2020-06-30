import UIKit
import RxSwift
import RxCocoa

final class LocationItemCell: UICollectionViewCell, NibReusable {
    struct Dependency {
        let element: LocationViewModel.Element
    }

    @IBOutlet weak private var mapView: GoogleMapView!
    @IBOutlet weak private var useButtonTitleLabel: UILabel!

    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }

    private func commonInit() {
    }

    func bind(_ dependency: Dependency) {
    }
}
