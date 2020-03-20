import UIKit

enum MonsterType {
    case small
    case big
    
    var image: UIImage {
        switch self {
        case .small:
            return UIImage(named: "sample_enemy_small")!
        case .big:
            return UIImage(named: "sample_enemy_big")!
        }
    }
}
