import UIKit
import DIKit
import RxSwift
import RxCocoa
import Domain

final class LocationViewController: UIViewController, FactoryMethodInjectable {
    struct Dependency {
        let viewModel: LocationViewModel
    }

    static func makeInstance(dependency: Dependency) -> LocationViewController {
        let viewController = StoryboardScene.LocationViewController.locationViewController.instantiate()
        viewController.dependency = dependency
        return viewController
    }

    private var dependency: Dependency!
    private let disposeBag = DisposeBag()

    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var collectionViewFlowLayout: UICollectionViewFlowLayout!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L10n.locationTitle
        bindViewModel()
    }

    private func bindViewModel() {
        let input = LocationViewModel.Input(
            disposeBag: disposeBag,
            refreshTrigger: rx.viewWillAppear.take(1).asDriver(onErrorDriveWith: .empty())
        )
        let output = dependency.viewModel.transform(input: input)
    }
}
