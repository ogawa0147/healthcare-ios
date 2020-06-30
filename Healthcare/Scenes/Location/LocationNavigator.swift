import UIKit
import DIKit
import RxSwift

protocol LocationNavigator {
    func toMain()
}

final class LocationNavigatorImpl: LocationNavigator, Injectable {
    struct Dependency {
        let resolver: AppResolver
        let navigationController: UINavigationController
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func toMain() {
        let usecase = dependency.resolver.provideUseCase()
        let viewController = dependency.resolver.resolveLocationViewController(navigator: self, locationTimelineUseCase: usecase.make())
        dependency.navigationController.pushViewController(viewController, animated: true)
    }
}
