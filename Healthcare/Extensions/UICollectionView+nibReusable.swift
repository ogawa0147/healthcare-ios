import UIKit

// from https://github.com/ra1028/DifferenceKit/blob/master/Examples/Example-iOS/Sources/Common/ReusableViewExtensions.swift

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellType: T.Type) where T: NibReusable {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(_ cellType: T.Type, kind: String) where T: NibReusable {
        register(cellType.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: cellType.reuseIdentifier)
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(at indexPath: IndexPath) -> T where T: NibReusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with type \(T.self)")
        }
        return cell
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(at indexPath: IndexPath, kind: String) -> T where T: NibReusable {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        return view
    }
}
