import UIKit
import DIKit
import RxSwift
import Domain

protocol HomeNavigator {
    func toMain()
}

final class HomeNavigatorImpl: HomeNavigator, Injectable {
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
        let viewController = dependency.resolver.resolveHomeViewController(navigator: self,
                                                                           authorizationUseCase: usecase.make(),
                                                                           homeTimelineUseCase: usecase.make())
        dependency.navigationController.pushViewController(viewController, animated: true)
    }
}
