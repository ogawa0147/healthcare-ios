import Foundation
import SwiftDate

// https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LocalizingYourApp/LocalizingYourApp.html#//apple_ref/doc/uid/10000171i-CH5-SW10
// https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/StringsdictFileFormat/StringsdictFileFormat.html#//apple_ref/doc/uid/10000171i-CH16-SW1
// http://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html
// https://github.com/SwiftGen/SwiftGen/pull/634
extension L10n {
    static func pluralsFormatSmartdrivePointsUnit(of number: Int) -> String {
        return String(format: NSLocalizedString("Plurals.Format.Step.Count.Unit", comment: ""), locale: SwiftDate.defaultRegion.locale, number)
    }
}
