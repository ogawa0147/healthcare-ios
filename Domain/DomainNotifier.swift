import Foundation
import RxSwift

final class DomainNotifier<T> {
    private let subject = PublishSubject<T>()

    var elements: Observable<T> {
        return subject.asObservable()
    }

    func notify(_ element: T) {
        subject.onNext(element)
    }

    deinit {
        subject.onCompleted()
    }
}
