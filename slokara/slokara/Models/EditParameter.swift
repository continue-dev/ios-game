import Foundation

struct EditParameter {
    let type: EditParamType
    let baseValue: Int64
    var addValur: Int64
}

enum EditParamType: Int {
    case hp
    case fire
    case water
    case wind
    case soil
    case light
    case darkness
    
    func asParameterType() -> ParameterType {
        switch self {
        case .hp:
            return .hp
        case .fire:
            return .attribute(type: .fire)
        case .water:
            return .attribute(type: .water)
        case .wind:
            return .attribute(type: .wind)
        case .soil:
            return .attribute(type: .soil)
        case .light:
            return .attribute(type: .light)
        case .darkness:
            return .attribute(type: .darkness)
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
