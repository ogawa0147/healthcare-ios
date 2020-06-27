import Foundation

extension Error {
    // swiftlint:disable superfluous_disable_command
    func convertToDomainError() -> DomainError {
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
