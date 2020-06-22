import UIKit
import DIKit
import Environments

protocol LaunchScreenNavigator {
    func makeMainWindow()
    func showLaunchScreen()
    func hideLaunchScreen()
}

final class LaunchScreenNavigatorImpl: LaunchScreenNavigator, Injectable {
    struct Dependency {
        let resolver: AppResolver
        let window: UIWindow?
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func makeMainWindow() {
        Application.shared.makeMainWindow(UIApplication.shared.keyWindow)
    }

    func showLaunchScreen() {
        let launchScreenView = StoryboardScene.LaunchScreen.initialScene.instantiate().view ?? UIView()
        dependency.window?.rootViewController?.view.addSubview(launchScreenView)
    }

    func hideLaunchScreen() {
        dependency.window?.rootViewController?.view.removeFromSuperview()
    }
}
