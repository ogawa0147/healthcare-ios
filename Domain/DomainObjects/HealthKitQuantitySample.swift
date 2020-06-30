import Foundation

public struct HealthKitQuantitySample {
    public let type: HealthKitQuantityType
    public let startDate: Date
    public let endDate: Date
    public let sumQuantity: Double

    public init(type: HealthKitQuantityType, startDate: Date, endDate: Date, sumQuantity: Double) {
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.sumQuantity = sumQuantity
    }
}
