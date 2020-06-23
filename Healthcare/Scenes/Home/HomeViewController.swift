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

    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var contentView: UIStackView!

    private struct Contents {
        static let stepCountOfMonthView: HomeActivityOfMonthView = .makeInstance()
        static let distanceWalkingRunningOfMonthView: HomeActivityOfMonthView = .makeInstance()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L10n.homeTitle
        configureContentView()
        bindViewModel()
    }

    private func configureContentView() {
        scrollView.refreshControl = UIRefreshControl(configuration: .init())
        contentView.addArrangedSubview(Contents.stepCountOfMonthView)
        contentView.addArrangedSubview(Contents.distanceWalkingRunningOfMonthView)
    }

    private func bindViewModel() {
        let refreshTrigger = Driver.merge(
            rx.viewWillAppear.take(1).asDriver(onErrorDriveWith: .empty()),
            scrollView.refreshControl!.rx.controlEvent(.valueChanged).asDriver()
        )
        let input = HomeViewModel.Input(
            disposeBag: disposeBag,
            refreshTrigger: refreshTrigger
        )
        let output = dependency.viewModel.transform(input: input)
        output.stepCountOfMonth
            .drive(onNext: { element in
                Contents.stepCountOfMonthView.bind(.init(element: element))
            })
            .disposed(by: disposeBag)
        output.distanceWalkingRunningOfMonth
            .drive(onNext: { element in
                Contents.distanceWalkingRunningOfMonthView.bind(.init(element: element))
            })
            .disposed(by: disposeBag)
        output.refreshing
            .drive(scrollView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
