import UIKit

class DormitoryViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var itemButton: UIButton!
    
    private let fontName = "07LogoTypeGothic7"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyButtonTitleFont()
    }
    
    private func applyButtonTitleFont() {
        self.statusButton.titleLabel?.font = UIFont(name: self.fontName, size: self.statusButton.titleLabel!.font.pointSize)
        self.itemButton.titleLabel?.font = UIFont(name: self.fontName, size: self.itemButton.titleLabel!.font.pointSize)
    }
    
    @IBAction func statusButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func itemButtonTapped(_ sender: Any) {
        // アイテム画面へ遷移
    }
}
