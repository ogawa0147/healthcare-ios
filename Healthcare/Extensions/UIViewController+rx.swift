import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    private func controlEvent(_ selector: Selector) -> ControlEvent<Void> {
        let source = self.methodInvoked(selector).map { _ in }
        return ControlEvent(events: source)
    }

    private func controlEvent(_ selector: Selector) -> ControlEvent<Bool> {
        let source = self.methodInvoked(selector).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    private func controlEvent(_ selector: Selector) -> ControlEvent<UIViewController?> {
        let source = self.methodInvoked(selector).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    var viewDidLoad: ControlEvent<Void> {
        return controlEvent(#selector(Base.viewDidLoad))
    }

    var viewWillAppear: ControlEvent<Void> {
        return controlEvent(#selector(Base.viewWillAppear))
    }

    var viewDidAppear: ControlEvent<Bool> {
        return controlEvent(#selector(Base.viewDidAppear))
    }

    var viewWillDisappear: ControlEvent<Bool> {
        return controlEvent(#selector(Base.viewWillDisappear))
    }

    var viewDidDisappear: ControlEvent<Bool> {
        return controlEvent(#selector(Base.viewDidDisappear))
    }

    var viewWillLayoutSubviews: ControlEvent<Void> {
        return controlEvent(#selector(Base.viewWillLayoutSubviews))
    }

    var viewDidLayoutSubviews: ControlEvent<Void> {
        return controlEvent(#selector(Base.viewDidLayoutSubviews))
    }

    var willMoveToParentViewController: ControlEvent<UIViewController?> {
        return controlEvent(#selector(Base.willMove))
    }

    var didMoveToParentViewController: ControlEvent<UIViewController?> {
        return controlEvent(#selector(Base.didMove))
    }

    var didReceiveMemoryWarning: ControlEvent<Void> {
        return controlEvent(#selector(Base.didReceiveMemoryWarning))
    }

    var isVisible: Observable<Bool> {
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = self.base.rx.viewWillDisappear.map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
    }

    var isDismissing: ControlEvent<Bool> {
        return controlEvent(#selector(Base.dismiss))
    }
}
