import Foundation
import DIKit
import RxSwift
import Action
import Logger

public protocol AuthorizationUseCase {
    var refreshTrigger: PublishSubject<Void> { get }

    var refreshing: Observable<Bool> { get }
    var errors: Observable<Error> { get }

    var authorized: Observable<Bool> { get }
}

final class AuthorizationUseCaseImpl: AuthorizationUseCase, Injectable {
    struct Dependency {
        let health: HealthKitType
    }

    private let disposeBag = DisposeBag()

    public let refreshTrigger: PublishSubject<Void> = .init()
    public let refreshing: Observable<Bool>
    public let errors: Observable<Error>
    public let authorized: Observable<Bool>

    init(dependency: Dependency) {
        let refreshingSubject = BehaviorSubject<Bool>(value: false)
        self.refreshing = refreshingSubject.asObservable()

        let errorSubject = PublishSubject<Error>()
        self.errors = errorSubject.asObservable()

        let authorizedSubject = BehaviorSubject<Bool>(value: false)
        self.authorized = authorizedSubject.asObservable()

        let refreshAction: Action<Void, Bool> = Action { _ in
            return Observable.create { observer in
                dependency.health.requestAuthorization { error, result in
                    if result {
                        observer.onNext(result)
                        observer.onCompleted()
                    } else {
                        Logger.error(error?.convertAPIErrorToDomainError() ?? HealthKitError.notAuthorization)
                        observer.onNext(result)
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
            .subscribe(onNext: authorizedSubject.onNext)
            .disposed(by: disposeBag)

        refreshAction.executing
            .subscribe(refreshingSubject)
            .disposed(by: disposeBag)

        refreshAction.underlyingError
            .subscribe(errorSubject)
            .disposed(by: disposeBag)
    }
}
