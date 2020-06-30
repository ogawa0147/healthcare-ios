import Foundation

protocol EntityObjectConvertibleType {
    associatedtype EntityObjectType

    func toEntityObject() -> EntityObjectType
}
