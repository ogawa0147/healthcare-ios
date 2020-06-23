import UIKit
import Domain

final class HomeActivityOfMonthView: UIView {
    struct Dependency {
        let element: Domain.QuantitySampleOfMonth
    }

    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var contentShadowView: UIView!
    @IBOutlet weak private var typeImageView: UIImageView!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var activityLabel: UILabel!
    @IBOutlet weak private var activityUnitLabel: UILabel!
    @IBOutlet weak private var timestampLabel: UILabel!

    static func makeInstance() -> HomeActivityOfMonthView {
        guard let view = UINib(nibName: "HomeActivityOfMonthView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? HomeActivityOfMonthView else {
            fatalError()
        }

        view.contentView.layer.cornerRadius = 8.0
        view.contentView.layer.borderWidth = 1.0
        view.contentView.layer.borderColor = UIColor.clear.cgColor
        view.contentView.layer.masksToBounds = true

        view.contentShadowView.layer.cornerRadius = 8.0
        view.contentShadowView.layer.shadowColor = UIColor(white: 0, alpha: 0.15).cgColor
        view.contentShadowView.layer.shadowOpacity = 1
        view.contentShadowView.layer.shadowRadius = 8
        view.contentShadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.contentShadowView.layer.masksToBounds = false

        view.dateLabel.text = "2020-01-01"
        view.activityLabel.text = "--"
        view.timestampLabel.text = "00:00-00:00"

        return view
    }

    func bind(_ dependency: Dependency) {
        switch dependency.element.quantityTypeId {
        case .stepCount:
            typeImageView.image = Asset.Assets.steps.image
            dateLabel.text = dependency.element.startDate.toYearMonthDayWeek()
            activityLabel.text = NumberFormatter.convert(of: dependency.element.sumQuantity, maximum: 0, divide: 1)
            activityUnitLabel.text = L10n.pluralsFormatSmartdrivePointsUnit(of: Int(dependency.element.sumQuantity))
            timestampLabel.text = "\(dependency.element.startDate.toHourMinute()) - \(dependency.element.endDate.toHourMinute())"
        case .distanceWalkingRunning:
            typeImageView.image = Asset.Assets.distance.image
            dateLabel.text = dependency.element.startDate.toYearMonthDayWeek()
            activityLabel.text = NumberFormatter.convert(of: dependency.element.sumQuantity, maximum: 2, divide: 1000.0)
            activityUnitLabel.text = MeasurementFormatter.unitName(of: .kilometers)
            timestampLabel.text = "\(dependency.element.startDate.toHourMinute()) - \(dependency.element.endDate.toHourMinute())"
        default:
            fatalError()
        }
    }
}
