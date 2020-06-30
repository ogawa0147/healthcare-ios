import Foundation
import DIKit
import RxSwift
import RxCocoa
import Domain

final class HomeViewModel: ViewModelType, Injectable {
    struct Dependency {
        let navigator: HomeNavigator
        let authorizationUseCase: HealthKitAuthorizationUseCase
        let homeTimelineUseCase: HomeTimelineUseCase
    }
    struct Input {
        let disposeBag: DisposeBag
        let refreshTrigger: Driver<Void>
    }
    struct Output {
        let stepCountOfMonth: Driver<Domain.HealthKitQuantitySample>
        let distanceWalkingRunningOfMonth: Driver<Domain.HealthKitQuantitySample>
        let distanceCyclingOfMonth: Driver<Domain.HealthKitQuantitySample>
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
        let stepCountOfMonth = dependency.homeTimelineUseCase.stepCount
        let distanceWalkingRunningOfMonth = dependency.homeTimelineUseCase.distanceWalkingRunning
        let distanceCyclingOfMonth = dependency.homeTimelineUseCase.distanceCycling

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
            stepCountOfMonth: stepCountOfMonth.asDriver(onErrorDriveWith: .empty()),
            distanceWalkingRunningOfMonth: distanceWalkingRunningOfMonth.asDriver(onErrorDriveWith: .empty()),
            distanceCyclingOfMonth: distanceCyclingOfMonth.asDriver(onErrorDriveWith: .empty()),
            refreshing: refreshing.asDriver(onErrorJustReturn: false),
            errors: errors.asDriver(onErrorDriveWith: .empty())
        )
    }
}
