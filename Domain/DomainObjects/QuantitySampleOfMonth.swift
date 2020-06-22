import Foundation
import HealthKit

public struct QuantitySampleOfMonth {
    public let startDate: Date
    public let endDate: Date
    public let quantityType: HKQuantityType
    public let sources: [HKSource]
    public let sumQuantity: Double

    public init(startDate: Date, endDate: Date, quantityType: HKQuantityType, sources: [HKSource], sumQuantity: HKQuantity?) {
        self.startDate = startDate
        self.endDate = endDate
        self.quantityType = quantityType
        self.sources = sources
        self.sumQuantity = sumQuantity?.doubleValue(for: HKUnit.count()) ?? 0
    }
}
