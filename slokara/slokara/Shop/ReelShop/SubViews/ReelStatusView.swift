import UIKit

class ReelStatusView: UIView {
    
    @IBOutlet private weak var topBridgeView: UIView!
    @IBOutlet private weak var bottomBredgeView: UIView!
    @IBOutlet private weak var leftBredgeView: UIView!
    @IBOutlet private weak var rightBredgeView: UIView!
    @IBOutlet private weak var reelImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setState(type: ShopReelStatus) {
        if case .hold(let contacts) = type {
            backgroundColor = contacts.count >= 4 ? .white : .black
            topBridgeView.isHidden = !contacts.contains(.top)
            bottomBredgeView.isHidden = !contacts.contains(.bottom)
            leftBredgeView.isHidden = !contacts.contains(.left)
            rightBredgeView.isHidden = !contacts.contains(.right)
        } else {
            backgroundColor = .clear
        }
        
        reelImageView.image = type.reelImage
    }
    
    private func setUp() {
        guard let view = Bundle.main.loadNibNamed("ReelStatusView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
    
    enum ShopReelStatus {
        case onSale                 // 購入可能
        case selected               // 選択中
        case hold([ContactArea])    // 保有済
        case center                 // 縦横4つのリールも含めて保有済
        case disable                // 非表示
        
        var reelImage: UIImage? {
            switch self {
            case .center, .hold(_):
                return UIImage(named: "shop_reel_acquired")
            case .onSale:
                return UIImage(named: "shop_reel_sale")
            case .selected:
                return UIImage(named: "shop_reel_selected")
            default:
                return nil
            }
        }
        
        enum ContactArea {
            case top, bottom, left, right
        }
    }
}
