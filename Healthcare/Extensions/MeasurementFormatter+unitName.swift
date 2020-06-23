import Foundation
import SwiftDate

// https://developer.apple.com/documentation/foundation/units_and_measurement
// https://developer.apple.com/documentation/foundation/measurementformatter/unitoptions
// https://developer.apple.com/documentation/foundation/unitlength
extension MeasurementFormatter {
    static func unitName(of unitType: UnitLength) -> String {
        switch unitType {
        case .kilometers:
            let formatter = MeasurementFormatter()
            formatter.locale = SwiftDate.defaultRegion.locale
            formatter.unitOptions = .providedUnit
            formatter.unitStyle = .medium
            let distance = Measurement(value: 0, unit: unitType)
            return formatter.string(from: distance.unit)
        case .meters:
            let formatter = MeasurementFormatter()
            formatter.locale = SwiftDate.defaultRegion.locale
            formatter.unitOptions = .providedUnit
            formatter.unitStyle = .medium
            let distance = Measurement(value: 0, unit: unitType)
            return formatter.string(from: distance.unit)
        default:
            return ""
        }
    }
}
