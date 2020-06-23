import Foundation
import HealthKit
import SwiftDate
import Logger

public protocol HealthKitType {
    func requestAuthorization(_ completion: @escaping (Error?, Bool) -> Void)
    func getMonthOfStepCount(_ completion: @escaping (Error?, QuantitySampleOfMonth?) -> Void)
}

final class HealthKitProvider: HealthKitType {
    private let store: HKHealthStore

    init() {
        self.store = HKHealthStore()
    }

    func requestAuthorization(_ completion: @escaping (Error?, Bool) -> Void) {
        let type: Set<HKSampleType> = [
            HKSampleType.quantityType(forIdentifier: .stepCount)!
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
        let date = Date()
        let type = HKSampleType.quantityType(forIdentifier: .stepCount)!
        let datePredicate = HKQuery.predicateForSamples(withStart: date.startOfMonth, end: date.endOfMonth)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: datePredicate, options: .separateBySource) { query, data, error in
            if let error = error {
                Logger.error("sample query error. \(error.localizedDescription)")
                return completion(error, nil)
            }
            guard let sources = data?.sources?.filter({ $0.bundleIdentifier.hasPrefix("com.apple.health") }) else {
                Logger.error("not found sample data.")
                return completion(HealthKitError.noData, nil)
            }
            let sourcesPredicate = HKQuery.predicateForObjects(from: Set(sources))
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, sourcesPredicate])
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, data, error in
                if let error = error {
                    Logger.error("sample query error. \(error.localizedDescription)")
                    return completion(error, nil)
                }
                guard let data = data else {
                    Logger.error("not found sample data.")
                    return completion(HealthKitError.noData, nil)
                }
                let collection = QuantitySampleOfMonth(startDate: data.startDate, endDate: data.endDate, quantityType: data.quantityType, sources: data.sources ?? [], sumQuantity: data.sumQuantity())
                return completion(nil, collection)
            }
            self.store.execute(query)
        }
        store.execute(query)
    }
}
