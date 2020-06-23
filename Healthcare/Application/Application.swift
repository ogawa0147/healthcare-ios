import UIKit
import SwiftDate
import Firebase
import FirebaseCrashlytics
import RxSwift
import Environments
import Logger

final class Application {
    static let shared = Application()

    private let resolver: AppResolver = AppResolverImpl()

    private init() {
        #if DEVELOPMENT
        Environments.shared.setEnviroment(.development)
        LogConfigure.shared.enable()
        #else
        Environments.shared.setEnviroment(.production)
        LogConfigure.shared.disable()
        #endif
    }

    func configureSwiftDate() {
        SwiftDate.defaultRegion = Region(calendar: Calendars.gregorian, zone: Zones.current, locale: Locales.current)
    }

    func configureFirebaseApp() {
        let options = FirebaseOptions(contentsOfFile: Constants.GoogleService.plistPath)!
        FirebaseApp.configure(options: options)
    }

    func configureFirestore() {
        let firestore = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        firestore.settings = settings
    }

    func makeLaunchWindow(_ window: UIWindow?) {
        let navigator = resolver.resolveLaunchScreenNavigatorImpl(window: window)
        let viewController = resolver.resolveLaunchScreenViewController(navigator: navigator)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
