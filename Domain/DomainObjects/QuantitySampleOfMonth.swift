import Foundation
import HealthKit

public struct QuantitySampleOfMonth {
    public let startDate: Date
    public let endDate: Date
    public let quantityType: HKQuantityType
    public let quantityTypeId: HKQuantityTypeIdentifier
    public let sources: [HKSource]
    public let sumQuantity: Double

    public init(startDate: Date, endDate: Date, quantityType: HKQuantityType, quantityTypeId: HKQuantityTypeIdentifier, sources: [HKSource], sumQuantity: Double) {
        self.startDate = startDate
        self.endDate = endDate
        self.quantityType = quantityType
        self.quantityTypeId = quantityTypeId
        self.sources = sources
        self.sumQuantity = sumQuantity
    }
}
