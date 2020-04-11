import Foundation

extension Array where Element: Hashable {
    func isEqualOfIndex(_ indexes: Int...) -> Bool {
        return Set(indexes.map { self[$0] }).count == 1
    }
}
