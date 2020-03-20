import UIKit
import SpriteKit
import RxSwift
import RxCocoa

class BattleViewController: UIViewController, NavigationChildViewController {

    @IBOutlet var topSpacer: UIView!
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var reelLeftTop: UIImageView!
    @IBOutlet weak var reelCenterTop: UIImageView!
    @IBOutlet weak var reelRightTop: UIImageView!
    @IBOutlet weak var reelLeftMiddle: UIImageView!
    @IBOutlet weak var reelCenterMiddle: UIImageView!
    @IBOutlet weak var reelRightMiddle: UIImageView!
    @IBOutlet weak var reelLeftBottom: UIImageView!
    @IBOutlet weak var reelCenterBottom: UIImageView!
    @IBOutlet weak var reelRightBottom: UIImageView!
    @IBOutlet weak var enemyImage: UIImageView!
    
    private var viewModel: BattleViewModel?
    
    override func viewDidLoad() {
        viewModel = BattleViewModel(
            reelImageArray: [
                reelLeftTop,
                reelCenterTop,
                reelRightTop,
                reelLeftMiddle,
                reelCenterMiddle,
                reelRightMiddle,
                reelLeftBottom,
                reelCenterBottom,
                reelRightBottom
            ],
            enemyImage: enemyImage,
            skView: skView
        )
    }
}
