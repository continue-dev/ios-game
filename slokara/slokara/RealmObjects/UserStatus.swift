import Foundation
import RealmSwift

class UserStatus: Object {
    @objc dynamic var maxHp: Int64 = 100
    @objc dynamic var currentHp: Int64 = 100
    @objc dynamic var numberOfCoins: Int = 0
    @objc dynamic var numberOfCredit: Int = 0
    @objc dynamic var gradeString: String = "wood"
    @objc dynamic var rankValue: Int = 1
    
    var grade: Grade {
        set { gradeString = newValue.rawValue }
        get { return Grade(rawValue: gradeString)! }
    }
}
