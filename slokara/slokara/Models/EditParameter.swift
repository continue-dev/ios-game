import Foundation

struct EditParameter {
    let type: EditParamType
    let baseValue: Int64
    var addValur: Int64
}

enum EditParamType {
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
}
