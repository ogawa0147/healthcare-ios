import UIKit

extension UIRefreshControl {
    struct Configuration {
        let color: UIColor = Asset.Colors.darkTheme.color
    }

    convenience init(configuration: Configuration) {
        self.init()
        self.tintColor = configuration.color
    }
}
