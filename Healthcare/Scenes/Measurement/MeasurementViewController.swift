import UIKit
import CoreLocation
import DIKit
import RxSwift
import RxCocoa
import Domain

final class MeasurementViewController: UIViewController, FactoryMethodInjectable {
    struct Dependency {
        let viewModel: MeasurementViewModel
    }

    static func makeInstance(dependency: Dependency) -> MeasurementViewController {
        let viewController = StoryboardScene.MeasurementViewController.measurementViewController.instantiate()
        viewController.dependency = dependency
        return viewController
    }

    private var dependency: Dependency!
    private let disposeBag = DisposeBag()

    @IBOutlet weak private var mapView: GoogleMapView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var contentView: UIStackView!
    @IBOutlet weak private var startButton: UIButton!
    @IBOutlet weak private var stopButton: UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L10n.measurementTitle
        bindViewModel()
    }

    private func bindViewModel() {
        let input = MeasurementViewModel.Input(
            disposeBag: disposeBag,
            refreshTrigger: rx.viewWillAppear.take(1).asDriver(onErrorDriveWith: .empty()),
            startTrigger: startButton.rx.tap.asDriver(),
            stopTrigger: stopButton.rx.tap.asDriver()
        )
        let output = dependency.viewModel.transform(input: input)
        output.locations
            .drive(onNext: { [weak self] locations in
                guard let self = self else { return }
                let coordinates: [CLLocationCoordinate2D] = locations.map {
                    .init(latitude: $0.latitude, longitude: $0.longitude)
                }
                let markers: [GoogleMapMarkerAttribute] = locations.map {
                    return .init(position: .init(latitude: $0.latitude, longitude: $0.longitude))
                }
                self.mapView.delay(seconds: 0.2) {
                    self.mapView.drawRoute(at: coordinates)
                    self.mapView.drawMarkers(markers)
                }
            })
            .disposed(by: disposeBag)
    }
}
