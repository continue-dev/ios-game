import SpriteKit
import RxSwift
import RxCocoa

final class  BattleViewModel {
    private let animationView: AnimationView = AnimationView()
    
    init(reelImageArray: [UIImageView], enemyImage: UIImageView, skView: SKView) {
        skView.backgroundColor = .white
        animationView.setReelImage(reel: reelImageArray)
        animationView.setEnemyImage(enemy: enemyImage)
        skView.presentScene(animationView)
    }
    
}
