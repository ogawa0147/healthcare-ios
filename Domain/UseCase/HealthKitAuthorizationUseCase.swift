import Foundation
import DIKit
import RxSwift
import Action
import Logger

public protocol HealthKitAuthorizationUseCase {
    var refreshTrigger: PublishSubject<Void> { get }

    var refreshing: Observable<Bool> { get }
    var errors: Observable<Error> { get }

    var authorized: Observable<Bool> { get }
}

final class HealthKitAuthorizationUseCaseImpl: HealthKitAuthorizationUseCase, Injectable {
    struct Dependency {
        let health: HealthKitType
        let notifiers: DomainNotifier<Bool>
    }

    private var dependency: Dependency
    private let disposeBag = DisposeBag()

    public let refreshTrigger: PublishSubject<Void> = .init()

    public let refreshing: Observable<Bool>
    public let errors: Observable<Error>

    public let authorized: Observable<Bool>

    init(dependency: Dependency) {
        self.dependency = dependency

        let refreshingSubject = BehaviorSubject<Bool>(value: false)
        self.refreshing = refreshingSubject.asObservable()

        let errorSubject = PublishSubject<Error>()
        self.errors = errorSubject.asObservable()

        let authorizedSubject = BehaviorSubject<Bool>(value: false)
        self.authorized = authorizedSubject.asObservable()

        let refreshAction: Action<Void, Bool> = Action { _ in
            return Observable.create { observer in
                return self.requestAuthorization().subscribe(onSuccess: { result in
                    observer.onNext(result)
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                })
            }
        }

        refreshTrigger
            .subscribe(refreshAction.inputs)
            .disposed(by: disposeBag)

        refreshAction.elements
            .do(onNext: dependency.notifiers.notify)
            .subscribe(onNext: authorizedSubject.onNext)
            .disposed(by: disposeBag)

        refreshAction.executing
            .subscribe(refreshingSubject)
            .disposed(by: disposeBag)

        refreshAction.underlyingError
            .subscribe(errorSubject)
            .disposed(by: disposeBag)
    }

    private func requestAuthorization() -> Single<Bool> {
        return Single.create { observer in
            self.dependency.health.requestAuthorization { error, result in
                if result {
                    observer(.success(result))
                } else {
                    Logger.error(error?.convertToDomainError() ?? DomainError.notAuthorization)
                    observer(.error(DomainError.notAuthorization))
                }
            }
            return Disposables.create()
        }
    }
}
