import Foundation

public protocol HealthKitType {
    func requestAuthorization(_ completion: @escaping (Error?, Bool) -> Void)
    func getMonthOfStepCount(_ completion: @escaping (Error?, QuantitySampleOfMonth?) -> Void)
    func getMonthOfDistanceWalkingRunning(_ completion: @escaping (Error?, QuantitySampleOfMonth?) -> Void)
    func getMonthOfDistanceCycling(_ completion: @escaping (Error?, QuantitySampleOfMonth?) -> Void)
}
