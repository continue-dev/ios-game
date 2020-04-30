import UIKit

enum AttributeType: Int, CaseIterable, Hashable, Codable {
    case fire
    case water
    case wind
    case soil
    case light
    case darkness
    case enemy
    
    var image: UIImage {
        switch self {
        case .fire:
            return UIImage(named: "fire")!
        case .water:
            return UIImage(named: "water")!
        case .wind:
            return UIImage(named: "wind")!
        case .soil:
            return UIImage(named: "soil")!
        case .light:
            return UIImage(named: "light")!
        case .darkness:
            return UIImage(named: "darkness")!
        case .enemy:
            return UIImage(named: "enemy")!
        }
    }
    
    var unfavorable: AttributeType? {
        switch self {
        case .fire:
            return .water
        case .water:
            return .soil
        case .wind:
            return .fire
        case .soil:
            return .wind
        case .light:
            return .darkness
        case .darkness:
            return .light
        case .enemy:
            return nil
        }
    }
    
    var advantageous: [AttributeType]? {
        switch self {
        case .fire:
            return [.wind]
        case .water:
            return [.fire]
        case .wind:
            return [.soil]
        case .soil:
            return [.water]
        case .light, .darkness:
            return [.fire, .water, .wind, .soil]
        case .enemy:
            return nil
        }
    }
}
