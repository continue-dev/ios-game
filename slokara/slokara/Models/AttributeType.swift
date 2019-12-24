import UIKit

enum AttributeType {
    case fire
    case water
    case wind
    case soil
    case light
    case darkness
    
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
        }
    }
}
