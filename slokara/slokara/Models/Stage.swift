import UIKit

struct Stage: Codable {
    let id: Int
    let backGroundName: String
    let enemies: [Enemy]
    
    var backGround: UIImage {
        return UIImage(named: backGroundName)!
    }
    
    func toJson() -> Data {
        guard let json = try? JSONEncoder().encode(self) else { fatalError("Stage encode failed.") }
        return json
    }
}
