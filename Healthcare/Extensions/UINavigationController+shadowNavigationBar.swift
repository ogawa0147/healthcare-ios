import UIKit

extension UINavigationController {
    func shadowNavigationBar() {
        navigationBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        navigationBar.layer.shadowOpacity = 1
        navigationBar.layer.shadowRadius = 15
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
