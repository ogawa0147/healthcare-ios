import Foundation
import DIKit
import RxSwift
import Action
import Logger

public protocol LocationTimelineUseCase {
    var refreshTrigger: PublishSubject<Void> { get }

    var refreshing: Observable<Bool> { get }
    var errors: Observable<Error> { get }

    var locations: Observable<[Location]> { get }
}

final class LocationTimelineUseCaseImpl: LocationTimelineUseCase, Injectable {
    struct Dependency {
        var database: DatabaseType
    }

    private let disposeBag = DisposeBag()

    public let refreshTrigger: PublishSubject<Void> = .init()

    public let refreshing: Observable<Bool>
    public let errors: Observable<Error>

    public let locations: Observable<[Location]>

    init(dependency: Dependency) {
        let refreshingSubject = BehaviorSubject<Bool>(value: false)
        self.refreshing = refreshingSubject.asObservable()

        let errorSubject = PublishSubject<Error>()
        self.errors = errorSubject.asObservable()

        let locationsSubject = PublishSubject<[Location]>()
        self.locations = locationsSubject.asObservable()

        let refreshAction: Action<Void, [Location]> = Action { _ in
            let locations = dependency.database.locationDatabase.findAll()
            return .just(locations)
        }

        refreshTrigger
            .subscribe(refreshAction.inputs)
            .disposed(by: disposeBag)

        refreshAction.elements
            .subscribe(onNext: locationsSubject.onNext)
            .disposed(by: disposeBag)

        refreshAction.executing
            .subscribe(refreshingSubject)
            .disposed(by: disposeBag)

        refreshAction.underlyingError
            .subscribe(errorSubject)
            .disposed(by: disposeBag)
    }
}
