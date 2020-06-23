import UIKit
import Domain

extension Error {
    func catchDomainError() -> Domain.DomainError {
        return self as? Domain.DomainError ?? Domain.DomainError.systemError
    }
}
