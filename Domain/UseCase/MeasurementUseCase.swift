import Foundation
import DIKit
import RxSwift
import Action
import Logger

public protocol MeasurementUseCase {
    var requestAuthorizationTrigger: PublishSubject<Void> { get }
    var fetchAuthorizeStatusTrigger: PublishSubject<Void> { get }

    var startLocationTrigger: PublishSubject<Void> { get }
    var stopLocationTrigger: PublishSubject<Void> { get }

    var status: Observable<LocationAuthorizationStatus> { get }

    var locations: Observable<[Location]> { get }
}

final class MeasurementUseCaseImpl: MeasurementUseCase, Injectable {
    struct Dependency {
        var location: LocationType
        var database: DatabaseType
    }

    private var dependency: Dependency
    private let disposeBag = DisposeBag()

    private let locationsSubject = PublishSubject<[Location]>()

    public let requestAuthorizationTrigger: PublishSubject<Void> = .init()
    public let fetchAuthorizeStatusTrigger: PublishSubject<Void> = .init()

    public let startLocationTrigger: PublishSubject<Void> = .init()
    public let stopLocationTrigger: PublishSubject<Void> = .init()

    public let status: Observable<LocationAuthorizationStatus>

    public let locations: Observable<[Location]>

    // swiftlint:disable function_body_length
    init(dependency: Dependency) {
        self.dependency = dependency

        let authorizeStatusSubject = BehaviorSubject<LocationAuthorizationStatus>(value: .denied)
        self.status = authorizeStatusSubject.asObservable()

        self.locations = locationsSubject.asObservable()

        self.dependency.location.delegate = self

        let requestAuthorizationAction: Action<Void, Void> = Action { _ in
            return Observable.create { observer in
                return self.requestAuthorization().subscribe(onSuccess: { _ in
                    observer.onNext(())
                    observer.onCompleted()
                })
            }
        }

        let fetchAuthorizationStatusAction: Action<Void, LocationAuthorizationStatus> = Action { _ in
            return Observable.create { observer in
                return self.authorizationStatus().subscribe(onSuccess: { status in
                    observer.onNext(status)
                    observer.onCompleted()
                })
            }
        }

        let startLocationAction: Action<Void, Void> = Action { _ in
            return Observable.create { observer in
                return self.startLocation().subscribe(onSuccess: { _ in
                    observer.onNext(())
                    observer.onCompleted()
                })
            }
        }

        let stopLocationAction: Action<Void, Void> = Action { _ in
            return Observable.create { observer in
                return self.stopLocation().subscribe(onSuccess: { _ in
                    observer.onNext(())
                    observer.onCompleted()
                })
            }
        }

        requestAuthorizationTrigger
            .subscribe(requestAuthorizationAction.inputs)
            .disposed(by: disposeBag)

        fetchAuthorizeStatusTrigger
            .subscribe(fetchAuthorizationStatusAction.inputs)
            .disposed(by: disposeBag)

        startLocationTrigger
            .subscribe(startLocationAction.inputs)
            .disposed(by: disposeBag)

        stopLocationTrigger
            .subscribe(stopLocationAction.inputs)
            .disposed(by: disposeBag)

        requestAuthorizationAction.elements
            .subscribe()
            .disposed(by: disposeBag)

        fetchAuthorizationStatusAction.elements
            .subscribe(onNext: authorizeStatusSubject.onNext)
            .disposed(by: disposeBag)

        startLocationAction.elements
            .subscribe()
            .disposed(by: disposeBag)

        stopLocationAction.elements
            .subscribe()
            .disposed(by: disposeBag)

        locationsSubject
            .subscribe(onNext: dependency.database.locationDatabase.save)
            .disposed(by: disposeBag)
    }

    private func requestAuthorization() -> Single<Void> {
        return Single.create { observer in
            self.dependency.location.requestAuthorization()
            observer(.success(()))
            return Disposables.create()
        }
    }

    private func authorizationStatus() -> Single<LocationAuthorizationStatus> {
        return Single.create { observer in
            observer(.success(self.dependency.location.authorizationStatus()))
            return Disposables.create()
        }
    }

    private func startLocation() -> Single<Void> {
        return Single.create { observer in
            let id = ID(rawValue: UUID().uuidString)
            self.dependency.location.startLocation(id: id)
            observer(.success(()))
            return Disposables.create()
        }
    }

    private func stopLocation() -> Single<Void> {
        return Single.create { observer in
            self.dependency.location.stopLocation()
            observer(.success(()))
            return Disposables.create()
        }
    }
}

// MARK: - LocationDelegate
extension MeasurementUseCaseImpl: LocationDelegate {
    func didUpdateLocations(_ locations: [Location]) {
        Logger.debug(locations)
        locationsSubject.onNext(locations)
    }
}
