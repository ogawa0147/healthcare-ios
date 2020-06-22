import Foundation
import SwiftDate

extension Date {
    func toYearMonthDayWeek() -> String {
        return self.formatterForRegion(format: "(E)dMMMyyyy", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toYearMonthDay() -> String {
        return self.formatterForRegion(format: "dMMMyyyy", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toYearMonthDayHourMinuteWeek() -> String {
        return self.formatterForRegion(format: "(E)mm:H dMMMyyyy", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toYear() -> String {
        return self.formatterForRegion(format: "yyyy", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toYearMonth() -> String {
        return self.formatterForRegion(format: "MMMyyyy", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toMonth() -> String {
        return self.formatterForRegion(format: "MMM", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toMonthDay() -> String {
        return self.formatterForRegion(format: "dMMM", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toMonthDayWeek() -> String {
        return self.formatterForRegion(format: "(E)dMMM", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toHourMinute() -> String {
        return self.formatterForRegion(format: "HHmm", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toISOFormat() -> String {
        let dateStr = self.formatterForRegion(format: nil, configuration: {
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
        let srcDate = dateStr.toDate("yyyy-MM-dd'T'HH:mm:ssZZZZZ", region: SwiftDate.defaultRegion)
        return srcDate!.toISO()
    }

    func toLongYearMonth() -> String {
        return self.formatterForRegion(format: "MMMMyyyy", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toLongYearMonthDay() -> String {
        return self.formatterForRegion(format: nil, configuration: {
            $0.dateStyle = .long
            $0.timeStyle = .none
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toLongYearMonthDayHourMinute() -> String {
        return self.formatterForRegion(format: nil, configuration: {
            $0.dateStyle = .long
            $0.timeStyle = .short
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }

    func toLongMonth() -> String {
        return self.formatterForRegion(format: "MMMM", configuration: {
            $0.dateFormat = DateFormatter.dateFormat(fromTemplate: $0.dateFormat!, options: 0, locale: SwiftDate.defaultRegion.locale)
            $0.calendar = SwiftDate.defaultRegion.calendar
            $0.timeZone = SwiftDate.defaultRegion.timeZone
        }).string(from: self)
    }
}
