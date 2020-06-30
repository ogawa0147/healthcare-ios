import Foundation

public protocol HealthKitType {
    func authorizationTypeList() -> [(type: HealthKitQuantityType, status: HealthKitAuthorizationStatus)]
    func requestAuthorization(_ completion: @escaping (Error?, Bool) -> Void)
    func getMonthOfStepCount(_ completion: @escaping (Error?, HealthKitQuantitySample?) -> Void)
    func getMonthOfDistanceWalkingRunning(_ completion: @escaping (Error?, HealthKitQuantitySample?) -> Void)
    func getMonthOfDistanceCycling(_ completion: @escaping (Error?, HealthKitQuantitySample?) -> Void)
}
