import UIKit

extension UIRefreshControl {
    struct Configuration {
        let color: UIColor = Asset.Colors.darkThemeRefreshControl.color
    }

    convenience init(configuration: Configuration) {
        self.init()
        self.tintColor = configuration.color
    }
}
