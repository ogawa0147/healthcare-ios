import UIKit
import Domain

final class HomeStepCountOfMonthView: UIView {
    struct Dependency {
        let element: Domain.QuantitySampleOfMonth
    }

    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var contentShadowView: UIView!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var stepCountLabel: UILabel!
    @IBOutlet weak private var stepCountUnitLabel: UILabel!
    @IBOutlet weak private var timestampLabel: UILabel!

    static func makeInstance() -> HomeStepCountOfMonthView {
        guard let view = UINib(nibName: "HomeStepCountOfMonthView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? HomeStepCountOfMonthView else {
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
        view.stepCountLabel.text = "--"
        view.timestampLabel.text = "00:00-00:00"

        return view
    }

    func bind(_ dependency: Dependency) {
        dateLabel.text = dependency.element.startDate.toYearMonthDayWeek()
        stepCountLabel.text = NumberFormatter.convert(of: dependency.element.sumQuantity, maximum: 0, divide: 1)
        stepCountUnitLabel.text = L10n.pluralsFormatSmartdrivePointsUnit(of: Int(dependency.element.sumQuantity))
        timestampLabel.text = "\(dependency.element.startDate.toHourMinute()) - \(dependency.element.endDate.toHourMinute())"
    }
}
