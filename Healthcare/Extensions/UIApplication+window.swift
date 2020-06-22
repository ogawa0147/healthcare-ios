import UIKit

extension UIApplication {
    var windowScene: UIWindowScene? {
        return connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }

    var keyWindow: UIWindow? {
        guard let windowScene = windowScene else {
            return nil
        }
        return UIWindow(windowScene: windowScene)
    }
}
