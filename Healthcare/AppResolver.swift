import Foundation
import DIKit
import Domain
import Infrastructure

protocol AppResolver: DIKit.Resolver {
    func provideResolver() -> AppResolver
    func provideUseCase() -> UseCase
}

final class AppResolverImpl: AppResolver {
    func provideResolver() -> AppResolver {
        return self
    }

    func provideUseCase() -> Domain.UseCase {
        return UseCaseImpl(health: HealthKitProvider())
    }
}
