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
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(title: L10n.tabBarHomeTitle, image: nil, selectedImage: nil)
        homeNavigationController.shadowNavigationBar()
        let homeNavigator = dependency.resolver.resolveHomeNavigatorImpl(navigationController: homeNavigationController)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            homeNavigationController
        ]

        homeNavigator.toMain()

        let previousViewController = dependency.window?.rootViewController
        dependency.window?.rootViewController = tabBarController
        previousViewController?.dismiss(animated: false)
    }

    func showLaunchScreen() {
        let launchScreenView = StoryboardScene.LaunchScreen.initialScene.instantiate().view ?? UIView()
        dependency.window?.rootViewController?.view.addSubview(launchScreenView)
    }

    func hideLaunchScreen() {
        dependency.window?.rootViewController?.view.removeFromSuperview()
    }
}
