import Foundation

extension Int64 {
    func toDate() -> Date {
        return Date(timeIntervalSince1970: Double(self))
    }
}
