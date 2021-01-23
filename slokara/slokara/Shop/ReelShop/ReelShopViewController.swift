import UIKit

class ReelShopViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var enterButton: BorderedButton!
    @IBOutlet private weak var currentCoinsLabel: BorderedLabel!
    @IBOutlet private weak var paymentCoinsLabel: BorderedLabel!
    @IBOutlet private weak var shoppingView: ReelShoppingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingView.setReelStatus(reel: Reel(top: [false, false, true], center: [false, true, false], bottom: [true, false, false]))

    }
}
