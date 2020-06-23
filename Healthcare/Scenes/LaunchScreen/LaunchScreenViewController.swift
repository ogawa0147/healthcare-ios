import UIKit
import DIKit
import RxSwift
import RxCocoa

final class LaunchScreenViewController: UIViewController, FactoryMethodInjectable {
    struct Dependency {
        let viewModel: LaunchScreenViewModel
    }

    static func makeInstance(dependency: Dependency) -> LaunchScreenViewController {
        let viewController = StoryboardScene.LaunchScreenViewController.launchScreenViewController.instantiate()
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
        bindViewModel()
    }

    private func bindViewModel() {
        let input = LaunchScreenViewModel.Input(
            disposeBag: disposeBag,
            refreshTrigger: rx.viewWillAppear.take(1).asDriver(onErrorDriveWith: .empty())
        )
        _ = dependency.viewModel.transform(input: input)
    }
}
