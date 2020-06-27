import Foundation

public protocol DomainObjectConvertibleType {
    associatedtype DomainObjectType

    func toDomainObject() -> DomainObjectType
}
