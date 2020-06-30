import UIKit
import DIKit
import RxSwift

protocol MeasurementNavigator {
    func toMain()
}

final class MeasurementNavigatorImpl: MeasurementNavigator, Injectable {
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
        let viewController = dependency.resolver.resolveMeasurementViewController(navigator: self, measurementUseCase: usecase.make())
        dependency.navigationController.pushViewController(viewController, animated: true)
    }
}
