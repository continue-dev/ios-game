import UIKit
import RxSwift

class BattleViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var reelView: ReelView!
    @IBOutlet private weak var progressView: BattleProgressView!
    @IBOutlet private weak var firstItemButton: UIButton!
    @IBOutlet private weak var secondItemButton: UIButton!
    @IBOutlet private weak var thirdItemButton: UIButton!
    @IBOutlet private weak var backGroundImageView: UIImageView!
    @IBOutlet private weak var enemyImageView: UIImageView!
    @IBOutlet private weak var autoButton: ToggleButton!
    
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
