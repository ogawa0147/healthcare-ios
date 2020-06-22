import UIKit
import Domain

final class HomeStepCountView: UIView {
    struct Dependency {
        let element: Domain.QuantitySampleOfMonth
    }

    @IBOutlet weak private var contentBackgroundView: UIView!
    @IBOutlet weak private var shadowLayerView: UIView!
    @IBOutlet weak private var distanceLabel: UILabel!
    @IBOutlet weak private var distanceUnitLabel: UILabel!
    @IBOutlet weak private var timestampLabel: UILabel!

    static func makeInstance() -> HomeStepCountView {
        guard let view = UINib(nibName: "HomeStepCountView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? HomeStepCountView else {
            fatalError()
        }

        view.contentBackgroundView.layer.cornerRadius = 8.0
        view.contentBackgroundView.layer.borderWidth = 1.0
        view.contentBackgroundView.layer.borderColor = UIColor.clear.cgColor
        view.contentBackgroundView.layer.masksToBounds = true

        view.shadowLayerView.layer.cornerRadius = 8.0
        view.shadowLayerView.layer.shadowColor = UIColor(white: 0, alpha: 0.15).cgColor
        view.shadowLayerView.layer.shadowOpacity = 1
        view.shadowLayerView.layer.shadowRadius = 8
        view.shadowLayerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.shadowLayerView.layer.masksToBounds = false

        view.distanceLabel.text = "--"
        view.timestampLabel.text = "00:00-00:00"

        return view
    }

    func bind(_ dependency: Dependency) {
        distanceLabel.text = NumberFormatter.convert(of: dependency.element.sumQuantity, maximum: 1, divide: 1000.0)
        timestampLabel.text = "\(dependency.element.startDate.toHourMinute()) - \(dependency.element.endDate.toHourMinute())"
    }
}
