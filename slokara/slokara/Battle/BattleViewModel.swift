import UIKit
import SpriteKit

class BattleViewModel: SKScene {
    
    var imageArray: [UIImageView]?
    let model: BattleModel = BattleModel()

    override func didMove(to view: SKView) {

    }
    
    func setImage(image: [UIImageView]) {
        imageArray = image
        for image1 in imageArray! {
            image1.image = model.array[Int.random(in: 0...5)]
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for image in imageArray! {
            image.image = model.array[Int.random(in: 0...5)]
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
