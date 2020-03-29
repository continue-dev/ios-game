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
    
    func rankUp() {
        switch grade {
        case .wood:
            if rankValue >= 3 {
                rankValue = 1
                grade = .stone
            } else {
                rankValue += 1
            }
        case .stone:
            if rankValue >= 3 {
                rankValue += 1
                grade = .copper
            } else {
                rankValue += 1
            }
        case .copper:
            if rankValue >= 6 {
                rankValue = 1
                grade = .silver
            } else {
                rankValue += 1
            }
        case .silver:
            if rankValue >= 3 {
                rankValue = 1
                grade = .gold
            } else {
                rankValue += 1
            }
        case .gold:
            if rankValue >= 3 {
                return
            } else {
                rankValue += 1
            }
        }
    }
}
