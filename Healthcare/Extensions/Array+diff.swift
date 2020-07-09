import Foundation

// iOS10 ~ iOS 12
// iOS13 => https://developer.apple.com/documentation/swift/array/3200716-difference
extension Array where Element: Hashable {
    typealias E = Element

    func diff(from items: [E], by isAppend: Bool = true) -> [E] {
        let all = self + items
        var counter: [E: Int] = [:]
        all.forEach { counter[$0] = (counter[$0] ?? 0) + 1 }
        if !isAppend {
            items.forEach { key in
                if let index = counter.firstIndex(where: { $0.key == key }) {
                    counter.remove(at: index)
                }
            }
        }
        return all.filter { (counter[$0] ?? 0) == 1 }
    }
}
