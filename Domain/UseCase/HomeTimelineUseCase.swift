import Foundation
import DIKit
import RxSwift
import Action
import Logger

public protocol HomeTimelineUseCase {
    var refreshTrigger: PublishSubject<Void> { get }

    var refreshing: Observable<Bool> { get }
    var errors: Observable<Error> { get }

    var sample: Observable<QuantitySampleOfMonth> { get }
}

final class HomeTimelineCaseImpl: HomeTimelineUseCase, Injectable {
    struct Dependency {
        let health: HealthKitType
    }

    private let disposeBag = DisposeBag()

    public let refreshTrigger: PublishSubject<Void> = .init()
    public let refreshing: Observable<Bool>
    public let errors: Observable<Error>
    public let sample: Observable<QuantitySampleOfMonth>

    init(dependency: Dependency) {
        let refreshingSubject = BehaviorSubject<Bool>(value: false)
        self.refreshing = refreshingSubject.asObservable()

        let errorSubject = PublishSubject<Error>()
        self.errors = errorSubject.asObservable()

        let sampleSubject = PublishSubject<QuantitySampleOfMonth>()
        self.sample = sampleSubject.asObservable()

        let refreshAction: Action<Void, QuantitySampleOfMonth> = Action { _ in
            return Observable.create { observer in
                dependency.health.getMonthOfStepCount { error, result in
                    if let result = result {
                        observer.onNext(result)
                        observer.onCompleted()
                    } else {
                        Logger.error(error?.convertAPIErrorToDomainError() ?? HealthKitError.noData)
                        observer.onError(error ?? HealthKitError.noData)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }

        refreshTrigger
            .subscribe(refreshAction.inputs)
            .disposed(by: disposeBag)

        refreshAction.elements
            .subscribe(onNext: sampleSubject.onNext)
            .disposed(by: disposeBag)

        refreshAction.executing
            .subscribe(refreshingSubject)
            .disposed(by: disposeBag)

        refreshAction.underlyingError
            .subscribe(errorSubject)
            .disposed(by: disposeBag)
    }
}
