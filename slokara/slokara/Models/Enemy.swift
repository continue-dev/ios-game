import UIKit

struct Enemy {
    let id: Int
    let name: String
    var hp: Int64
    let attack: Int64
    let defense: Int64
    let attackType: [AttributeType]
    let defenseType: [AttributeType]
    let image: UIImage
    let type: EnemyType
    let probability: Probability
    
    enum EnemyType {
        case small
        case big
    }
}

