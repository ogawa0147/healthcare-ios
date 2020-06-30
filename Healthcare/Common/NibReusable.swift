import UIKit

// from https://github.com/ra1028/DifferenceKit/blob/master/Examples/Example-iOS/Sources/Common/NibLoadable.swift
// from https://github.com/ra1028/DifferenceKit/blob/master/Examples/Example-iOS/Sources/Common/Reusable.swift

protocol NibReusable: class {
    static var nibName: String { get }
    static var nibBundle: Bundle? { get }
    static var reuseIdentifier: String { get }
}

extension NibReusable {
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nibBundle)
    }

    static var nibName: String {
        return String(describing: self)
    }

    static var nibBundle: Bundle? {
        return Bundle(for: self)
    }

    static var reuseIdentifier: String {
        return String(reflecting: self)
    }
}
