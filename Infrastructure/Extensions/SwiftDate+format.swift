import Foundation
import SwiftDate

extension Date {
    var startOfMonth: Date {
        return self.dateAt(.startOfMonth).date
    }
    var endOfMonth: Date {
        return self.dateAt(.endOfMonth).date
    }
}
