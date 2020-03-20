import UIKit
import SpriteKit

class AnimationView: SKScene {
    
    private var reelImage: [UIImageView]?
    private var enemyImage: UIImageView?
    
    var touchesCounter: Int = 0

    override func didMove(to view: SKView) {

    }
    
    func randomReelImage() {
        for reel in reelImage! {
            let random = Int.random(in: 0...5)
            switch random {
            case 0:
                reel.image = AttributeType.fire.image
            case 1:
                reel.image = AttributeType.water.image
            case 2:
                reel.image = AttributeType.wind.image
            case 3:
                reel.image = AttributeType.soil.image
            case 4:
                reel.image = AttributeType.light.image
            case 5:
                reel.image = AttributeType.darkness.image
            default:
                reel.image = AttributeType.fire.image
            }
        }
    }
    
    func setReelImage(reel: [UIImageView]) {
        reelImage = reel
        randomReelImage()
    }
    func setEnemyImage(enemy: UIImageView) {
        enemyImage = enemy
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // ここの処理は動きを見るための仮実装
        randomReelImage()
        touchesCounter += 1
        if touchesCounter % 6 == 3 {
            enemyImage?.image = MonsterType.small.image
        }
        if touchesCounter % 6 == 0 {
            enemyImage?.image = MonsterType.big.image
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}

