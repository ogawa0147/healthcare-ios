import Foundation
import SwiftDate

extension NumberFormatter {
    static func convert(of value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = SwiftDate.defaultRegion.locale
        formatter.numberStyle = .decimal
        return formatter.string(from: value as NSNumber)!
    }

    // from https://developer.apple.com/documentation/foundation/nsnumberformatter?language=objc
    static func convert(of value: Double, minimum: Int = 1, maximum: Int, divide: Double = 0.0, roundingMode: NumberFormatter.RoundingMode = .floor) -> String {
        let formatter = NumberFormatter()
        formatter.locale = SwiftDate.defaultRegion.locale
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimum
        formatter.maximumFractionDigits = maximum
        formatter.roundingMode = roundingMode
        return formatter.string(from: value / divide as NSNumber)!
    }
}
