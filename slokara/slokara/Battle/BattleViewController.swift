import UIKit
import SpriteKit

class BattleViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var reelView: ReelView!
    @IBOutlet private weak var progressView: BattleProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reelView.line = .triple
        self.progressView.progressMax = 5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.progressView.nextStep()
    }
}
