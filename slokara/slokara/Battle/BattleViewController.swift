import UIKit
import SpriteKit
import RxSwift
import RxCocoa

class BattleViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    
    @IBOutlet weak var image11: UIImageView!
    @IBOutlet weak var image12: UIImageView!
    @IBOutlet weak var image13: UIImageView!
    @IBOutlet weak var image21: UIImageView!
    @IBOutlet weak var image22: UIImageView!
    @IBOutlet weak var image23: UIImageView!
    @IBOutlet weak var image31: UIImageView!
    @IBOutlet weak var image32: UIImageView!
    @IBOutlet weak var image33: UIImageView!
    @IBOutlet weak var skView001: SKView!
    
    override func viewDidLoad() {
        let scene = BattleViewModel(size: skView001.frame.size)
        scene.backgroundColor = .red
        scene.setImage(image: [image11, image12, image13, image21, image22, image23, image31, image32, image33])

        skView001.presentScene(scene)

    }
}
