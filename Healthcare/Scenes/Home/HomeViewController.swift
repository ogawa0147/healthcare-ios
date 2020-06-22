import UIKit
import DIKit
import RxSwift
import RxCocoa
import Domain

final class HomeViewController: UIViewController, FactoryMethodInjectable {
    struct Dependency {
        let viewModel: HomeViewModel
    }

    static func makeInstance(dependency: Dependency) -> HomeViewController {
        let viewController = StoryboardScene.HomeViewController.homeViewController.instantiate()
        viewController.dependency = dependency
        return viewController
    }

    private var dependency: Dependency!
    private let disposeBag = DisposeBag()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L10n.homeTitle
        bindViewModel()
    }

    private func bindViewModel() {
        let input = HomeViewModel.Input(
            disposeBag: disposeBag,
            refreshTrigger: rx.viewWillAppear.take(1).asDriver(onErrorDriveWith: .empty())
        )
        let output = dependency.viewModel.transform(input: input)
    }
}
