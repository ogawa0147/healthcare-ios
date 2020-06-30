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

        let locationNavigationController = UINavigationController()
        locationNavigationController.tabBarItem = UITabBarItem(title: L10n.tabBarLocationTitle, image: nil, selectedImage: nil)
        locationNavigationController.shadowNavigationBar()
        let locationNavigator = dependency.resolver.resolveLocationNavigatorImpl(navigationController: locationNavigationController)

        let measurementNavigationController = UINavigationController()
        measurementNavigationController.tabBarItem = UITabBarItem(title: L10n.tabBarMeasurementTitle, image: nil, selectedImage: nil)
        measurementNavigationController.shadowNavigationBar()
        let measurementNavigator = dependency.resolver.resolveMeasurementNavigatorImpl(navigationController: measurementNavigationController)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            homeNavigationController,
            locationNavigationController,
            measurementNavigationController
        ]

        homeNavigator.toMain()
        locationNavigator.toMain()
        measurementNavigator.toMain()

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
