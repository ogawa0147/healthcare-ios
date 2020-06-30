import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class LocationDataSource: NSObject, UICollectionViewDataSource, RxCollectionViewDataSourceType {
    typealias Element = [LocationViewModel.Section]
    var items: Element = []

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].elements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LocationItemCell = collectionView.dequeueReusableCell(at: indexPath)
        cell.bind(.init(elements: items[indexPath.section].elements))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        guard case .next(let newItems) = observedEvent else {
            return
        }
        items = newItems
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: LocationSectionHeader = collectionView.dequeueReusableSupplementaryView(at: indexPath, kind: kind)
            header.bind(.init(title: items[indexPath.section].title))
            return header
        }
        return UICollectionReusableView()
    }
}
