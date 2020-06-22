import Foundation
import DIKit
import RxSwift
import RxCocoa
import Domain
import Environments

final class LaunchScreenViewModel: ViewModelType, Injectable {
    struct Dependency {
        let navigator: LaunchScreenNavigator
    }
    struct Input {
        let disposeBag: DisposeBag
        let refreshTrigger: Driver<Void>
    }
    struct Output {}

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func transform(input: Input) -> Output {
        input.refreshTrigger.asObservable()
            .subscribe(onNext: dependency.navigator.makeMainWindow)
            .disposed(by: input.disposeBag)
        return Output()
    }
}
