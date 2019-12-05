import UIKit

enum Grade {
    case wood
    case stone
    case copper
    case silver
    case gold
    
    mutating func advancement() {
        switch self {
        case .wood:
            self = .stone
        case .stone:
            self = .copper
        case .copper:
            self = .silver
        case .silver:
            self = .gold
        case .gold:
            self = .gold
        }
    }
    
    var emblemImage: UIImage? {
        switch self {
        case .wood:
            return UIImage(named: "emblem_wood")
        case .stone:
            return UIImage(named: "emblem_stone")
        case .copper:
            return UIImage(named: "emblem_copper")
        case .silver:
            return UIImage(named: "emblem_silver")
        case .gold:
            return UIImage(named: "emblem_gold")
        }
    }
    
    var textBorderColor: UIColor {
        switch self {
        case .wood:
            return UIColor(red: 116.0/256, green: 81.0/256, blue: 49.0/256, alpha: 1)
        case .stone:
            return UIColor(red: 125.0/256, green: 106.0/256, blue: 87.0/256, alpha: 1)
        case .copper:
            return UIColor(red: 165.0/256, green: 95.0/256, blue: 28.0/256, alpha: 1)
        case .silver:
            return UIColor(red: 124.0/256, green: 119.0/256, blue: 105.0/256, alpha: 1)
        case .gold:
            return UIColor(red: 126.0/256, green: 109.0/256, blue: 47.0/256, alpha: 1)
        }
    }
    
    var name: String {
        switch self {
        case .wood:
            return "幼等部"
        case .stone, .copper:
            return "小等部"
        case .silver:
            return "中等部"
        case .gold:
            return "高等部"
        }
    }
}
