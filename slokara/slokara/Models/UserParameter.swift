import Foundation

struct UserParameter {
    let fireAttack: Int64
    let waterAttack: Int64
    let windAttack: Int64
    let soilAttack: Int64
    let lightAttack: Int64
    let darknessAttack: Int64
    let maxHp: Int64
    let defenseType: [AttributeType]
    
    var defense: Int64 {
        return (fireAttack + waterAttack + windAttack + soilAttack + lightAttack + darknessAttack) / 10
    }
    
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
