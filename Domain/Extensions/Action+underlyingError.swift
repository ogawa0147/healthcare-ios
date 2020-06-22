import Foundation
import RxSwift
import Action

extension Action {
    var underlyingError: Observable<Error> {
        return errors.flatMap { actionError -> Observable<Error> in
            switch actionError {
            case .notEnabled:
                return .empty()
            case .underlyingError(let error):
                return .just(error)
            }
        }
    }
}
