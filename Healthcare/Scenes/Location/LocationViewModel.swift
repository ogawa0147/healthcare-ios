import Foundation
import DIKit
import RxSwift
import RxCocoa
import Domain

final class LocationViewModel: ViewModelType, Injectable {
    struct Dependency {
        let navigator: LocationNavigator
        let locationTimelineUseCase: LocationTimelineUseCase
    }
    struct Input {
        let disposeBag: DisposeBag
        let refreshTrigger: Driver<Void>
    }
    struct Output {
        let locations: Driver<[Domain.Location]>
        let refreshing: Driver<Bool>
        let errors: Driver<Domain.DomainError>
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func transform(input: Input) -> Output {
        let refreshing = dependency.locationTimelineUseCase.refreshing
        let errors = dependency.locationTimelineUseCase.errors.map { $0.catchDomainError() }
        let locations = dependency.locationTimelineUseCase.locations

        input.refreshTrigger.asObservable()
            .subscribe(onNext: dependency.locationTimelineUseCase.refreshTrigger.onNext)
            .disposed(by: input.disposeBag)

        return Output(
            locations: locations.asDriver(onErrorDriveWith: .empty()),
            refreshing: refreshing.asDriver(onErrorJustReturn: false),
            errors: errors.asDriver(onErrorDriveWith: .empty())
        )
    }
}
