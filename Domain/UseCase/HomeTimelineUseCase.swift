import Foundation
import DIKit
import RxSwift
import Action
import Logger

public protocol HomeTimelineUseCase {
    var refreshTrigger: PublishSubject<Void> { get }

    var refreshing: Observable<Bool> { get }
    var errors: Observable<Error> { get }

    var stepCount: Observable<HealthKitQuantitySample> { get }
    var distanceWalkingRunning: Observable<HealthKitQuantitySample> { get }
    var distanceCycling: Observable<HealthKitQuantitySample> { get }
}

final class HomeTimelineCaseImpl: HomeTimelineUseCase, Injectable {
    struct Dependency {
        let health: HealthKitType
        let notifiers: DomainNotifier<Bool>
    }

    private let disposeBag = DisposeBag()

    public let refreshTrigger: PublishSubject<Void> = .init()

    public let refreshing: Observable<Bool>
    public let errors: Observable<Error>

    public let stepCount: Observable<HealthKitQuantitySample>
    public let distanceWalkingRunning: Observable<HealthKitQuantitySample>
    public let distanceCycling: Observable<HealthKitQuantitySample>

    // swiftlint:disable function_body_length
    init(dependency: Dependency) {
        let refreshingSubject = BehaviorSubject<Bool>(value: false)
        self.refreshing = refreshingSubject.asObservable()

        let errorSubject = PublishSubject<Error>()
        self.errors = errorSubject.asObservable()

        let stepCountSubject = PublishSubject<HealthKitQuantitySample>()
        self.stepCount = stepCountSubject.asObservable()

        let distanceWalkingRunningSubject = PublishSubject<HealthKitQuantitySample>()
        self.distanceWalkingRunning = distanceWalkingRunningSubject.asObservable()

        let distanceCyclingSubject = PublishSubject<HealthKitQuantitySample>()
        self.distanceCycling = distanceCyclingSubject.asObservable()

        let fetchMonthOfStepCountAction: Action<Void, HealthKitQuantitySample> = Action { _ in
            return Observable.create { observer in
                dependency.health.getMonthOfStepCount { error, result in
                    if let result = result {
                        observer.onNext(result)
                        observer.onCompleted()
                    } else {
                        Logger.error(error?.convertToDomainError() ?? HealthKitError.noData)
                        observer.onError(error ?? HealthKitError.noData)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }

        let fetchMonthOfDistanceWalkingRunningAction: Action<Void, HealthKitQuantitySample> = Action { _ in
            return Observable.create { observer in
                dependency.health.getMonthOfDistanceWalkingRunning { error, result in
                    if let result = result {
                        observer.onNext(result)
                        observer.onCompleted()
                    } else {
                        Logger.error(error?.convertToDomainError() ?? HealthKitError.noData)
                        observer.onError(error ?? HealthKitError.noData)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }

        let fetchMonthOfDistanceCyclingAction: Action<Void, HealthKitQuantitySample> = Action { _ in
            return Observable.create { observer in
                dependency.health.getMonthOfDistanceCycling { error, result in
                    if let result = result {
                        observer.onNext(result)
                        observer.onCompleted()
                    } else {
                        Logger.error(error?.convertToDomainError() ?? HealthKitError.noData)
                        observer.onError(error ?? HealthKitError.noData)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }

        refreshTrigger
            .subscribe(fetchMonthOfStepCountAction.inputs)
            .disposed(by: disposeBag)

        refreshTrigger
            .subscribe(fetchMonthOfDistanceWalkingRunningAction.inputs)
            .disposed(by: disposeBag)

        refreshTrigger
            .subscribe(fetchMonthOfDistanceCyclingAction.inputs)
            .disposed(by: disposeBag)

        fetchMonthOfStepCountAction.elements
            .subscribe(onNext: stepCountSubject.onNext)
            .disposed(by: disposeBag)

        fetchMonthOfDistanceWalkingRunningAction.elements
            .subscribe(onNext: distanceWalkingRunningSubject.onNext)
            .disposed(by: disposeBag)

        fetchMonthOfDistanceCyclingAction.elements
            .subscribe(onNext: distanceCyclingSubject.onNext)
            .disposed(by: disposeBag)

        Observable.merge(fetchMonthOfStepCountAction.executing, fetchMonthOfDistanceWalkingRunningAction.executing, fetchMonthOfDistanceCyclingAction.executing)
            .subscribe(refreshingSubject)
            .disposed(by: disposeBag)

        Observable.merge(fetchMonthOfStepCountAction.underlyingError, fetchMonthOfDistanceWalkingRunningAction.underlyingError, fetchMonthOfDistanceCyclingAction.underlyingError)
            .subscribe(errorSubject)
            .disposed(by: disposeBag)

        let authorized = dependency.notifiers.elements.filter { $0 }.map { _ in }.take(1)

        authorized
            .subscribe(fetchMonthOfStepCountAction.inputs)
            .disposed(by: disposeBag)

        authorized
            .subscribe(fetchMonthOfDistanceWalkingRunningAction.inputs)
            .disposed(by: disposeBag)

        authorized
            .subscribe(fetchMonthOfDistanceCyclingAction.inputs)
            .disposed(by: disposeBag)
    }
}
