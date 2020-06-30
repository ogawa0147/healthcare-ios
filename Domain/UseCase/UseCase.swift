import Foundation

public protocol UseCase {
    func make() -> HealthKitAuthorizationUseCase
    func make() -> HomeTimelineUseCase
    func make() -> LocationTimelineUseCase
    func make() -> MeasurementUseCase
}

public final class UseCaseImpl: UseCase {
    private let resolver = DomainResolverImpl()

    private let health: HealthKitType
    private let location: LocationType
    private let database: DatabaseType

    private let notifiers: Notifiers

    private struct Notifiers {
        let authorized: DomainNotifier<Bool> = .init()
    }

    public init(health: HealthKitType, location: LocationType, database: DatabaseType) {
        self.health = health
        self.location = location
        self.database = database
        self.notifiers = .init()
    }

    public func make() -> HealthKitAuthorizationUseCase {
        return resolver.resolveHealthKitAuthorizationUseCaseImpl(health: health, notifiers: notifiers.authorized)
    }

    public func make() -> HomeTimelineUseCase {
        return resolver.resolveHomeTimelineCaseImpl(health: health, notifiers: notifiers.authorized)
    }

    public func make() -> LocationTimelineUseCase {
        return resolver.resolveLocationTimelineUseCaseImpl(database: database)
    }

    public func make() -> MeasurementUseCase {
        return resolver.resolveMeasurementUseCaseImpl(location: location, database: database)
    }
}
