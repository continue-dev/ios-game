import UIKit

struct EditParameter {
    let type: EditParamType
    let baseValue: Int64
    var addValue: Int64
}

enum EditParamType: Int {
    case hp
    case fire
    case water
    case wind
    case soil
    case light
    case darkness
    
    var color: UIColor {
        switch self {
        case .hp:
            return UIColor(named: "hpBarColor")!
        case .fire:
            return AttributeType.fire.color
        case .water:
            return AttributeType.water.color
        case .wind:
            return AttributeType.wind.color
        case .soil:
            return AttributeType.soil.color
        case .light:
            return AttributeType.light.color
        case .darkness:
            return AttributeType.darkness.color
        }
    }
    
    var image: UIImage {
        switch self {
        case .hp:
            return UIImage(named: "heart_with_hp")!
        case .fire:
            return AttributeType.fire.image
        case .water:
            return AttributeType.water.image
        case .wind:
            return AttributeType.wind.image
        case .soil:
            return AttributeType.soil.image
        case .light:
            return AttributeType.light.image
        case .darkness:
            return AttributeType.darkness.image
        }
    }
    
    init(editingType: EditingType) {
        switch editingType {
        case .hp:
            self = .hp
        case .fire:
            self = .fire
        case .water:
            self = .water
        case .wind:
            self = .wind
        case .soil:
            self = .soil
        case .light:
            self = .light
        case .darkness:
            self = .darkness
        default:
            fatalError("Can not initialize EditParamType from \(editingType)")
        }
    }
}
