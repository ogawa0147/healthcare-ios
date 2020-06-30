import Foundation
import DIKit
import RxSwift
import RxCocoa
import Domain

final class LocationViewModel: ViewModelType, Injectable {
    struct Dependency {
        let navigator: LocationNavigator
        let locationTimelineUseCase: LocationTimelineUseCase
    }
    struct Input {
        let disposeBag: DisposeBag
        let refreshTrigger: Driver<Void>
    }
    struct Output {
        let sections: Driver<[Section]>
        let refreshing: Driver<Bool>
        let errors: Driver<Domain.DomainError>
    }

    private let dependency: Dependency

    struct Section {
        let title: String?
        let elements: [Element]
    }
    struct Element {
        let element: Domain.Location
    }

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func transform(input: Input) -> Output {
        let refreshing = dependency.locationTimelineUseCase.refreshing
        let errors = dependency.locationTimelineUseCase.errors.map { $0.catchDomainError() }
        let sections: Observable<[Section]> = dependency.locationTimelineUseCase.locations.map { locations in
            let elements: [Element] = locations.map { location in
                return .init(element: location)
            }
            let groupedElements: [String: [Element]] = Dictionary(grouping: elements) { element -> String in
                return element.element.date.toYearMonthDay()
            }
            .reduce(into: [String: [Element]]()) { groups, elements in
                groups[elements.key] = elements.value.sorted { $0.element.date < $1.element.date }
            }
            let sortedDateList = groupedElements.keys.sorted(by: { $0 > $1 })
            var sections: [Section] = []
            sortedDateList.forEach { group in
                sections.append(.init(title: group, elements: groupedElements[group] ?? []))
            }
            return sections
        }

        input.refreshTrigger.asObservable()
            .subscribe(onNext: dependency.locationTimelineUseCase.refreshTrigger.onNext)
            .disposed(by: input.disposeBag)

        return Output(
            sections: sections.asDriver(onErrorDriveWith: .empty()),
            refreshing: refreshing.asDriver(onErrorJustReturn: false),
            errors: errors.asDriver(onErrorDriveWith: .empty())
        )
    }
}
