import Foundation
import DIKit

protocol DomainResolver: DIKit.Resolver {
    func provideResolver() -> DomainResolver
}

final class DomainResolverImpl: DomainResolver {
    func provideResolver() -> DomainResolver {
        return self
    }
}
