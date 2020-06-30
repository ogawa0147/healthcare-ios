import Foundation
import HealthKit
import SwiftDate
import Domain
import Logger

public final class HealthKitService: Domain.HealthKitType {
    private let store: HKHealthStore

    public init() {
        self.store = HKHealthStore()
    }

    public func authorizationTypeList() -> [(type: Domain.HealthKitQuantityType, status: Domain.HealthKitAuthorizationStatus)] {
        return [
            (type: .distanceCycling, status: store.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: .distanceCycling)!).toDomainObject()),
            (type: .stepCount, status: store.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: .stepCount)!).toDomainObject()),
            (type: .distanceWalkingRunning, status: store.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!).toDomainObject())
        ]
    }

    public func requestAuthorization(_ completion: @escaping (Error?, Bool) -> Void) {
        let type: Set<HKSampleType> = [
            HKSampleType.quantityType(forIdentifier: .stepCount)!,
            HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKSampleType.quantityType(forIdentifier: .distanceCycling)!
        ]
        store.requestAuthorization(toShare: nil, read: type) { result, error in
            if let error = error {
                Logger.error("request for handling healthcare data has failed.")
                return completion(error, result)
            }
            Logger.info("request for handling healthcare data was successful.")
            completion(nil, result)
        }
    }

    public func getMonthOfStepCount(_ completion: @escaping (Error?, Domain.HealthKitQuantitySample?) -> Void) {
        fetchMonthSample(of: .stepCount) { error, type, data in
            if let error = error {
                Logger.error("failed to fetch the step count. \(error.localizedDescription)")
                return completion(error, nil)
            }
            guard let data = data else {
                Logger.error("step count data not found.")
                return completion(Domain.HealthKitError.noData, nil)
            }
            let sample = Domain.HealthKitQuantitySample(
                type: type.toDomainObject(),
                startDate: data.startDate,
                endDate: data.endDate,
                sumQuantity: data.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            )
            Logger.debug("step count data. \(sample)")
            return completion(nil, sample)
        }
    }

    public func getMonthOfDistanceWalkingRunning(_ completion: @escaping (Error?, Domain.HealthKitQuantitySample?) -> Void) {
        fetchMonthSample(of: .distanceWalkingRunning) { error, type, data in
            if let error = error {
                Logger.error("failed to fetch the distance walking running. \(error.localizedDescription)")
                return completion(error, nil)
            }
            guard let data = data else {
                Logger.error("distance walking running data not found.")
                return completion(Domain.HealthKitError.noData, nil)
            }
            let sample = Domain.HealthKitQuantitySample(
                type: type.toDomainObject(),
                startDate: data.startDate,
                endDate: data.endDate,
                sumQuantity: data.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
            )
            Logger.debug("distance walking running data. \(sample)")
            return completion(nil, sample)
        }
    }

    public func getMonthOfDistanceCycling(_ completion: @escaping (Error?, Domain.HealthKitQuantitySample?) -> Void) {
        fetchMonthSample(of: .distanceCycling) { error, type, data in
            if let error = error {
                Logger.error("failed to fetch the distance cycling. \(error.localizedDescription)")
                return completion(error, nil)
            }
            guard let data = data else {
                Logger.error("distance cycling data not found.")
                return completion(Domain.HealthKitError.noData, nil)
            }
            let sample = Domain.HealthKitQuantitySample(
                type: type.toDomainObject(),
                startDate: data.startDate,
                endDate: data.endDate,
                sumQuantity: data.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
            )
            Logger.debug("distance cycling data. \(sample)")
            return completion(nil, sample)
        }
    }

    private func fetchMonthSample(of quantityType: HKQuantityTypeIdentifier, _ completion: @escaping (Error?, HKQuantityTypeIdentifier, HKStatistics?) -> Void) {
        let date = Date()
        let type = HKSampleType.quantityType(forIdentifier: quantityType)!
        let datePredicate = HKQuery.predicateForSamples(withStart: date.startOfMonth, end: date.endOfMonth)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: datePredicate, options: .separateBySource) { query, data, error in
            if let error = error {
                Logger.error("failed to fetch the sample. \(error.localizedDescription)")
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
                    Logger.error("failed to fetch the sample. \(error.localizedDescription)")
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

extension HKQuantityTypeIdentifier: Domain.DomainObjectConvertibleType {
    public func toDomainObject() -> Domain.HealthKitQuantityType {
        switch self {
        case .distanceCycling:
            return .distanceCycling
        case .stepCount:
            return .stepCount
        case .distanceWalkingRunning:
            return .distanceWalkingRunning
        default:
            fatalError()
        }
    }
}

extension HKAuthorizationStatus: Domain.DomainObjectConvertibleType {
    public func toDomainObject() -> Domain.HealthKitAuthorizationStatus {
        switch self {
        case .notDetermined:
            return .notDetermined
        case .sharingDenied:
            return .sharingDenied
        case .sharingAuthorized:
            return .sharingAuthorized
        default:
            fatalError()
        }
    }
}
