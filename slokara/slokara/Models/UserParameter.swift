import Foundation

struct UserParameter {
    let fireAttack: Int64
    let waterAttack: Int64
    let windAttack: Int64
    let soilAttack: Int64
    let lightAttack: Int64
    let darknessAttack: Int64
    let defense: Int64
    let maxHp: Int64
    let defenseType: [AttributeType]
    
    func attackPower(of type: AttributeType) -> Int64 {
        switch type {
        case .fire:
            return fireAttack
        case .water:
            return waterAttack
        case .wind:
            return windAttack
        case .soil:
            return soilAttack
        case .light:
            return lightAttack
        case .darkness:
            return darknessAttack
        default:
            return 0
        }
    }
}
