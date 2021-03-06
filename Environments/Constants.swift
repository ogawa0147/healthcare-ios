import Foundation

public final class Constants {

    public static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    public static var identifier: String {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }

    public struct GoogleService {
        public static var plistPath: String {
            return Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        }
        public static var contents: NSDictionary {
            return NSDictionary(contentsOfFile: plistPath)!
        }
        public static var apiKey: String {
            return contents["API_KEY"] as? String ?? ""
        }
        public static var staticMapURL: URL {
            return URL(string: "https://maps.googleapis.com/maps/api/staticmap")!
        }
    }
}
