import Foundation
import DIKit
import RxSwift
import Action
import Logger

public protocol AuthorizationUseCase {
    var refreshTrigger: PublishSubject<Void> { get }

    var authorized: Observable<Bool> { get }
}

final class AuthorizationUseCaseImpl: AuthorizationUseCase, Injectable {
    struct Dependency {
        let health: HealthKitType
    }

    private let disposeBag = DisposeBag()

    public let refreshTrigger: PublishSubject<Void> = .init()
    public let authorized: Observable<Bool>

    init(dependency: Dependency) {
        let authorizedSubject = BehaviorSubject<Bool>(value: false)
        self.authorized = authorizedSubject.asObservable()

        let refreshAction: Action<Void, Bool> = Action { date in
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
    }
}
