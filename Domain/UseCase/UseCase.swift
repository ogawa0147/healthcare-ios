import Foundation

public protocol UseCase {
    func make() -> AuthorizationUseCase
    func make() -> HomeTimelineUseCase
}

public final class UseCaseImpl: UseCase {
    private let resolver = DomainResolverImpl()

    private let health: HealthKitType

    public init() {
        self.health = HealthKitProvider()
    }

    public func make() -> AuthorizationUseCase {
        return resolver.resolveAuthorizationUseCaseImpl(health: health)
    }

    public func make() -> HomeTimelineUseCase {
        return resolver.resolveHomeTimelineCaseImpl(health: health)
    }
}
