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
    private let dataSource = LocationDataSource()

    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var collectionViewFlowLayout: UICollectionViewFlowLayout!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L10n.locationTitle
        configureCollectionView()
        bindViewModel()
    }

    private func configureCollectionView() {
        collectionView.register(LocationItemCell.self)
        collectionView.register(LocationSectionHeader.self, kind: UICollectionView.elementKindSectionHeader)
        collectionViewFlowLayout.minimumLineSpacing = 16.0
        collectionViewFlowLayout.minimumInteritemSpacing = 16.0
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 15.0, right: 10.0)
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 50)
    }

    private func bindViewModel() {
        let input = LocationViewModel.Input(
            disposeBag: disposeBag,
            refreshTrigger: rx.viewWillAppear.take(1).asDriver(onErrorDriveWith: .empty())
        )
        let output = dependency.viewModel.transform(input: input)
        output.sections
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LocationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32.0, height: (collectionView.frame.width - 32.0) * 2.0)
    }
}
