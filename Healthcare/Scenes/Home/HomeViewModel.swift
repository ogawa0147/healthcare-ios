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
        let sampleOfMonth: Driver<Domain.QuantitySampleOfMonth>
        let refreshing: Driver<Bool>
        let errors: Driver<Domain.DomainError>
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func transform(input: Input) -> Output {
        let refreshing = dependency.homeTimelineUseCase.refreshing
        let errors = dependency.homeTimelineUseCase.errors.map { $0.catchDomainError() }
        let authorized = dependency.authorizationUseCase.authorized
        let sampleOfMonth = dependency.homeTimelineUseCase.sample

        input.refreshTrigger.asObservable()
            .subscribe(onNext: dependency.homeTimelineUseCase.refreshTrigger.onNext)
            .disposed(by: input.disposeBag)

        input.refreshTrigger.asObservable()
            .subscribe(onNext: dependency.authorizationUseCase.refreshTrigger.onNext)
            .disposed(by: input.disposeBag)

        authorized
            .subscribe()
            .disposed(by: input.disposeBag)

        return Output(
            sampleOfMonth: sampleOfMonth.asDriver(onErrorDriveWith: .empty()),
            refreshing: refreshing.asDriver(onErrorJustReturn: false),
            errors: errors.asDriver(onErrorDriveWith: .empty())
        )
    }
}
