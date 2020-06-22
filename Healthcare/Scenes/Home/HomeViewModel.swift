import Foundation
import DIKit
import RxSwift
import RxCocoa
import Domain

final class HomeViewModel: ViewModelType, Injectable {
    struct Dependency {
        let navigator: HomeNavigator
        let authorizationUseCase: AuthorizationUseCase
        let homeTimelineUseCase: HomeTimelineUseCase
    }
    struct Input {
        let disposeBag: DisposeBag
        let refreshTrigger: Driver<Void>
    }
    struct Output {
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func transform(input: Input) -> Output {
        let authorized = dependency.authorizationUseCase.authorized
        let sample = dependency.homeTimelineUseCase.sample

        input.refreshTrigger.asObservable()
            .subscribe(onNext: dependency.homeTimelineUseCase.refreshTrigger.onNext)
            .disposed(by: input.disposeBag)

        input.refreshTrigger.asObservable()
            .subscribe(onNext: dependency.authorizationUseCase.refreshTrigger.onNext)
            .disposed(by: input.disposeBag)

        authorized
            .subscribe()
            .disposed(by: input.disposeBag)

        sample
            .subscribe()
            .disposed(by: input.disposeBag)

        return Output(
        )
    }
}
