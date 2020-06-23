import Foundation
import HealthKit
import SwiftDate
import Logger

public protocol HealthKitType {
    func requestAuthorization(_ completion: @escaping (Error?, Bool) -> Void)
    func getMonthOfStepCount(_ completion: @escaping (Error?, QuantitySampleOfMonth?) -> Void)
    func getMonthOfDistanceWalkingRunning(_ completion: @escaping (Error?, QuantitySampleOfMonth?) -> Void)
}

final class HealthKitProvider: HealthKitType {
    private let store: HKHealthStore

    init() {
        self.store = HKHealthStore()
    }

    func requestAuthorization(_ completion: @escaping (Error?, Bool) -> Void) {
        let type: Set<HKSampleType> = [
            HKSampleType.quantityType(forIdentifier: .stepCount)!,
            HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        store.requestAuthorization(toShare: nil, read: type) { result, error in
            if result {
                Logger.info("request authorization success.")
                completion(nil, result)
            } else {
                Logger.error("request authorization error.")
                completion(error, result)
            }
        }
    }

    func getMonthOfStepCount(_ completion: @escaping (Error?, QuantitySampleOfMonth?) -> Void) {
        fetchMonthSample(of: .stepCount) { error, type, data in
            if let error = error {
                Logger.error("step count query error. \(error.localizedDescription)")
                return completion(error, nil)
            }
            guard let data = data else {
                Logger.error("step count data not found.")
                return completion(HealthKitError.noData, nil)
            }
            let sample = QuantitySampleOfMonth(
                startDate: data.startDate,
                endDate: data.endDate,
                quantityType: data.quantityType,
                quantityTypeId: type,
                sources: data.sources ?? [],
                sumQuantity: data.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            )
            return completion(nil, sample)
        }
    }

    func getMonthOfDistanceWalkingRunning(_ completion: @escaping (Error?, QuantitySampleOfMonth?) -> Void) {
        fetchMonthSample(of: .distanceWalkingRunning) { error, type, data in
            if let error = error {
                Logger.error("distance walking running query error. \(error.localizedDescription)")
                return completion(error, nil)
            }
            guard let data = data else {
                Logger.error("distance walking running data not found.")
                return completion(HealthKitError.noData, nil)
            }
            let sample = QuantitySampleOfMonth(
                startDate: data.startDate,
                endDate: data.endDate,
                quantityType: data.quantityType,
                quantityTypeId: type,
                sources: data.sources ?? [],
                sumQuantity: data.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
            )
            return completion(nil, sample)
        }
    }

    private func fetchMonthSample(of quantityType: HKQuantityTypeIdentifier, _ completion: @escaping (Error?, HKQuantityTypeIdentifier, HKStatistics?) -> Void) {
        let date = Date()
        let type = HKSampleType.quantityType(forIdentifier: quantityType)!
        let datePredicate = HKQuery.predicateForSamples(withStart: date.startOfMonth, end: date.endOfMonth)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: datePredicate, options: .separateBySource) { query, data, error in
            if let error = error {
                Logger.error("sample query error. \(error.localizedDescription)")
                return completion(error, quantityType, nil)
            }
            guard let sources = data?.sources?.filter({ $0.bundleIdentifier.hasPrefix("com.apple.health") }) else {
                Logger.error("not found sample data.")
                return completion(HealthKitError.noData, quantityType, nil)
            }
            let sourcesPredicate = HKQuery.predicateForObjects(from: Set(sources))
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, sourcesPredicate])
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, data, error in
                if let error = error {
                    Logger.error("sample query error. \(error.localizedDescription)")
                    return completion(error, quantityType, nil)
                }
                guard let data = data else {
                    Logger.error("not found sample data.")
                    return completion(HealthKitError.noData, quantityType, nil)
                }
                return completion(nil, quantityType, data)
            }
            self.store.execute(query)
        }
        store.execute(query)
    }
}
