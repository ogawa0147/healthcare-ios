import Foundation

public enum DomainError: Error {
    case systemError
    case notAuthorization
    case noData
}

extension Error {
    // swiftlint:disable superfluous_disable_command
    func convertAPIErrorToDomainError() -> DomainError {
        if let error = self as? HealthKitError {
            switch error {
            case .notAuthorization:
                return .notAuthorization
            case .noData:
                return .noData
            }
        }
        return .systemError
    }
}
