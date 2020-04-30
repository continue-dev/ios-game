import UIKit

struct Enemy: Codable {
    let id: Int
    let name: String
    var hp: Int64
    let attack: Int64
    let defense: Int64
    let attackType: [AttributeType]
    let defenseType: [AttributeType]
    let imageName: String
    let type: EnemyType
    let probability: Probability
    
    var image: UIImage {
        return UIImage(named: imageName)!
    }
    
    enum EnemyType: Int, Codable {
        case small
        case big
    }
}

