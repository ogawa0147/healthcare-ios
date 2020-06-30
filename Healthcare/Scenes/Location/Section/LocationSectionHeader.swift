import UIKit

final class LocationSectionHeader: UICollectionReusableView, NibReusable {
    struct Dependency {
        let title: String?
    }

    @IBOutlet weak private var borderView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func commonInit() {
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = titleLabel.textColor.cgColor
        borderView.layer.cornerRadius = 19.0
        borderView.clipsToBounds = true
    }

    func bind(_ dependency: Dependency) {
        titleLabel.text = dependency.title
    }
}
