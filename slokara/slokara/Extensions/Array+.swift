import Foundation

extension Array where Element: Hashable {
    func isEqualOfIndex(_ indexes: Int...) -> Bool {
        return Set(indexes.map { self[$0] }).count == 1
    }
}

extension Array {
    func separate(of size: Int) -> [[Element]] {
        var selfArray = self
        var result = [[Element]]()
        while selfArray.count > 0 {
            result.append(Array(selfArray.prefix(size)))
            selfArray = selfArray.suffix(selfArray.count - size)
        }
        return result
    }
}
