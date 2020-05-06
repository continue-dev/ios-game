import UIKit

struct Reel: Codable {
    var top = [false, false, false]
    var center = [false, false, false]
    var bottom = [true, true, true]
    
    func isEmptyLine(_ line: [Bool]) -> Bool {
        return !line.contains(true)
    }
    
    var lines: ReelLine {
        let lines = [top, center, bottom].map { $0.filter { $0 } }.filter { !$0.isEmpty }.count
        switch lines {
        case 1:
            return .single
        case 2:
            return .double
        case 3:
            return .triple
        default:
            fatalError("Out of index from reel lines.")
        }
    }
    
    var enableLines: [[Bool]] {
        return [top, center, bottom].filter { $0.contains(true) }
    }
    
}

enum ReelLine {
    case single
    case double
    case triple
    
    var frameImage: UIImage? {
        switch self {
        case .single:
            return UIImage(named: "reel_frame_single")
        case .double:
            return UIImage(named: "reel_frame_double")
        case .triple:
            return UIImage(named: "reel_frame_triple")
        }
    }
}
