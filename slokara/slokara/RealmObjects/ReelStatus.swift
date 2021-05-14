import Foundation
import RealmSwift

class ReelStatus: Object {
    @objc dynamic var topLeft: Bool = false
    @objc dynamic var topCenter: Bool = false
    @objc dynamic var topRight: Bool = false
    @objc dynamic var middleLeft: Bool = false
    @objc dynamic var middleCenter: Bool = true
    @objc dynamic var middleRight: Bool = false
    @objc dynamic var bottomLeft: Bool = false
    @objc dynamic var bottomCenter: Bool = false
    @objc dynamic var bottomRight: Bool = false
}
