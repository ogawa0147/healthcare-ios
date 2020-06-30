import Foundation
import DIKit
import RxSwift
import RxCocoa
import Domain

final class MeasurementViewModel: ViewModelType, Injectable {
    struct Dependency {
        let navigator: MeasurementNavigator
        let measurementUseCase: MeasurementUseCase
    }
    struct Input {
        let disposeBag: DisposeBag
        let refreshTrigger: Driver<Void>
        let startTrigger: Driver<Void>
        let stopTrigger: Driver<Void>
    }
    struct Output {
        var locations: Driver<[Domain.Location]>
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func transform(input: Input) -> Output {
        let status = dependency.measurementUseCase.status
        let locations = dependency.measurementUseCase.locations

        input.refreshTrigger.asObservable()
            .subscribe(onNext: dependency.measurementUseCase.requestAuthorizationTrigger.onNext)
            .disposed(by: input.disposeBag)

        input.refreshTrigger.asObservable()
            .subscribe(onNext: dependency.measurementUseCase.fetchAuthorizeStatusTrigger.onNext)
            .disposed(by: input.disposeBag)

        input.startTrigger.asObservable()
            .subscribe(onNext: dependency.measurementUseCase.startLocationTrigger.onNext)
            .disposed(by: input.disposeBag)

        input.stopTrigger.asObservable()
            .subscribe(onNext: dependency.measurementUseCase.stopLocationTrigger.onNext)
            .disposed(by: input.disposeBag)

        status
            .subscribe()
            .disposed(by: input.disposeBag)

        locations
            .subscribe()
            .disposed(by: input.disposeBag)

        return Output(
            locations: locations.asDriver(onErrorDriveWith: .empty())
        )
    }
}
